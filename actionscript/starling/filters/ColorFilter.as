
package starling.filters
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;
	
	import starling.textures.Texture;
	
	public class ColorFilter extends FragmentFilter {
		
		//private static const FRAGMENT_SHADER:String =
		//<![CDATA[
		//// Move the coordinates into a temporary register
		//mov ft0, v0
		//
		//mov ft0.rgb, fc0.rgb
		//mul ft0.a, ft0.a, fc0.a
		//
		//// Move the updated texture to the output channel
		//mov oc, ft0
		//]]>
		
		private var recolor:Vector.<Number> = new <Number>[1.0, 1.0, 1.0, 1.0];
		private var shaderProgram:Program3D;
		
		private var mR:Number;
		private var mG:Number;
		private var mB:Number;
		private var mA:Number;
		
		public function ColorFilter(r:Number, g:Number, b:Number, a:Number = 1.0) {
			mR = r;
			mG = g;
			mB = b;
			mA = a;
			super();
		}
		
		public override function dispose():void {
			if (shaderProgram) shaderProgram.dispose();
			super.dispose();
		}
		
		protected override function createPrograms():void {
				
			shaderProgram = assembleAgal(
				"tex ft0, v0, fs0<2d, clamp, linear, nomip> \n" +
				"mul ft0.w, ft0.w, fc0.w \n" +
				"mov ft0.xyz, fc0.xyz \n" +
				"mul ft0.xyz, ft0.xyz, ft0.www \n" +
				"mov oc, ft0 \n");
		}
 
		protected override function activate(pass:int, context:Context3D, texture:Texture):void
		{
			// already set by super class:
			// 
			// vertex constants 0-3: mvpMatrix (3D)
			// vertex attribute 0:   vertex position (FLOAT_2)
			// vertex attribute 1:   texture coordinates (FLOAT_2)
			// texture 0:            input texture
			
			recolor[0] = mR;
			recolor[1] = mG;
			recolor[2] = mB;
			recolor[3] = mA;
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, recolor, 1);
			context.setProgram(shaderProgram);
		}
	}
}