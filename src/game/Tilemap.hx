package game;

import colliders.BoxCollider;
import colliders.Collider;
import colliders.CollisionInformation;
import colliders.HasCollider;
import colliders.PolygonCollider;
import game.objects.BaseObject;
import game.Tilemap.ObjectLayer;
import haxe.xml.Fast;
import flash.utils.ByteArray;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.AssetManager;
import utility.Point;

enum Orientation {
  Orthogonal;
  Isometric;
  IsometricStaggered;
  HexagonalStaggered;
}

enum RenderOrder {
  RightDown;
  RightUp;
  LeftDown;
  LeftUp;
}

class Tile {
  public var id:Int;
  public var width:Int;
  public var height:Int;
  public var source:String;
  // properties

  public function new() {
  }
}

class Object {
  public var id:Float;
  public var width:Float;
  public var height:Float;
  public var x:Float;
  public var y:Float;
  public var points:Array<Point>;
  // properties

  public function new() {
  }
}

class Layer {
  public var name:String;
  public var data:Array<Array<Tile>>;
  public var visible:Bool;
  // properties

  public function new() {
    data = new Array<Array<Tile>>();
  }
}

class ObjectLayer {
  public var name:String;
  public var data:Array<Object>;
  // properties

  public function new() {
    data = new Array<Object>();
  }
}

class Tilemap extends BaseObject implements HasCollider {

  public var mapWidth(default, null):Int;
  public var mapHeight(default, null):Int;
  public var tileWidth(default, null):Int;
  public var tileHeight(default, null):Int;
  public var orientation(default, null):Orientation;
  public var renderOrder(default, null):RenderOrder;
  public var tiles:Array<Tile>;
  public var layers:Array<Layer>;
  public var objectLayers:Array<ObjectLayer>;
  public var _assets:AssetManager;
  
  private var colliders:Array<Collider>;

  public function new(world:World, assets:AssetManager, xml:String) {
    super(world);
    _assets = assets;

    var xml = Xml.parse(haxe.Resource.getString(xml));
    var source = new Fast(xml.firstElement());

    var txt:String;

    txt = source.att.orientation;
    if (txt == "") {
      orientation = Orientation.Orthogonal;
    } else if (txt == "orthogonal") {
      orientation = Orientation.Orthogonal;
    } else if (txt == "isometric") {
      orientation = Orientation.Isometric;
    } else if (txt == "isometric-staggered") {
      orientation = Orientation.IsometricStaggered;
    } else if (txt == "hexagonal-staggered") {
      orientation = Orientation.HexagonalStaggered;
    }

    txt = source.att.renderorder;
    if (txt == "") {
      renderOrder = RenderOrder.RightDown;
    } else if (txt == "right-down") {
      renderOrder = RenderOrder.RightDown;
    } else if (txt == "right-up") {
      renderOrder = RenderOrder.RightUp;
    } else if (txt == "left-down") {
      renderOrder = RenderOrder.LeftDown;
    } else if (txt == "left-up") {
      renderOrder = RenderOrder.LeftUp;
    }

    mapWidth = Std.parseInt(source.att.width);
    mapHeight = Std.parseInt(source.att.height);

    tileWidth = Std.parseInt(source.att.tilewidth);
    tileHeight = Std.parseInt(source.att.tileheight);

    tiles = new Array<Tile>();
    for (tileset in source.nodes.tileset) {
      if (tileset.has.source) {
        throw "External tileset source not supported.";
      }
      if (tileset.has.margin || tileset.has.spacing) {
        throw "Only image collections are supported.";
      }

      for (tile in tileset.nodes.tile) {
        if (tile.has.id) {
          var t = new Tile();
          t.id = Std.parseInt(tile.att.id);
          for (image in tile.nodes.image) {
            t.width = Std.parseInt(image.att.width);
            t.height = Std.parseInt(image.att.height);
            t.source = image.att.source;
            t.source = t.source.substr(0, t.source.length-4);
          }
          tiles.push(t);
        }
      }
    }

    layers = new Array<Layer>();
    for (layer in source.nodes.layer) {
      var t = new Layer();
      t.name = layer.att.name;
      for (i in 0...mapHeight) {
        t.data.push(new Array<Tile>());
        for (j in 0...mapWidth) {
          t.data[i].push(null);
        }
      }
      var i = 0;
      for (data in layer.nodes.data) {
        for (tile in data.nodes.tile) {
          t.data[Std.int(i / mapWidth)][Std.int(i % mapWidth)] = tiles[Std.parseInt(tile.att.gid)-1];
          i += 1;
        }
      }
      layers.push(t);
    }
	
	objectLayers = new Array<ObjectLayer>();
	for (layer in source.nodes.objectgroup) {
		var ol = new ObjectLayer();
		ol.name = layer.att.name;
		for ( object in layer.nodes.object ) {
			var o = new Object();
			o.id = Std.parseInt(object.att.id);
			o.x = Std.parseFloat(object.att.x);
			o.y = Std.parseFloat(object.att.y);
			if (object.hasNode.polygon) {
				o.points = new Array<Point>();
				var pointsStr:String = object.nodes.polygon.first().att.points;
				var pointsArr = pointsStr.split(" ");
				var i:Int;
				for (pt in pointsArr) {
					i = pt.indexOf(",");
					o.points.push(new Point(Std.parseFloat(pt.substr(0, i)), Std.parseFloat(pt.substr(i+1))));
				}
			} else {
				o.width = Std.parseFloat(object.att.width);
				o.height = Std.parseFloat(object.att.height);
			}
			ol.data.push(o);
		}
		objectLayers.push(ol);
	}

	//var i:Int = 0;
    for (layer in layers) {
	//if (i == 2) {

      // The default is renderOrder == RenderOrder.RightDown
      var xi = 0;
      var xf = mapWidth;
      var dx = 1;
      var yi = 0;
      var yf = mapHeight;
      var dy = 1;
      
      if (renderOrder == RenderOrder.RightUp) {
        xi = 0;
        xf = mapWidth;
        dx = 1;
        yi = mapHeight-1;
        yf = -1;
        dy = -1;
      }

      if (renderOrder == RenderOrder.LeftDown) {
        xi = mapWidth-1;
        xf = -1;
        dx = -1;
        yi = 0;
        yf = mapHeight;
        dy = 1;
      }

      if (renderOrder == RenderOrder.LeftUp) {
        xi = mapWidth-1;
        xf = -1;
        dx = -1;
        yi = mapHeight-1;
        yf = -1;
        dy = -1;
      }

      var _x = 0;
      var _y = 0;
      while (_y != yf) {
        while (_x != xf) {
          var cell = layer.data[_y][_x];
          if (cell != null && cell.source != null && cell.source != "") {
            var img = new Image(_assets.getTexture(cell.source));
			img.smoothing = "none";
            img.pivotY = img.height;
            img.x = _x*tileWidth;
            img.y = _y*tileHeight + 16;
            addChild(img);
          }
          _x += dy;
        }
        _x = xi;
        _y += dy;
      }
	//}
	//i += 1;
    }
	
	this.colliders = new Array<Collider>();
	for (layer in objectLayers) {
		if (layer.name.indexOf("_Collisions") >= 0) {
			for ( object in layer.data) {
				if (object.points != null) {
					var collider = new PolygonCollider(this, ["map"], object.points);
					collider.x = object.x;
					collider.y = object.y;
					this.addChild(collider);
					this.colliders.push(collider);
				} else {
					var collider = new BoxCollider(this, ["map"], object.width, object.height, new Point(object.width / 2.0, object.height / 2.0));
					collider.x = object.x;
					collider.y = object.y;
					this.addChild(collider);
					this.colliders.push(collider);
				}
			}
		}
	}

  }
  
  public override function getColliders():Array<Collider> { return this.colliders; }

}
