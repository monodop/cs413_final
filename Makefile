FLEX_SDK = C:\Program Files (x86)\Apache Flex\flexsdk
ADL = $(FLEX_SDK)/bin/adl
AMXMLC = $(FLEX_SDK)/bin/amxmlc
SOURCES = src/*.hx assets/loadingimage.png

all: clean game.swf test

pixelFilter.swf:
	$(FLEX_SDK)/bin/compc \
	-source-path actionscript \
	-include-sources actionscript \
	-external-library-path+=vendor/starling_1_6.swc \
	-external-library-path+=$(FLEX_SDK)/frameworks/libs/core.swc \
	-output vendor/pixelFilter.swc

game.swf: $(SOURCES)
	haxe \
	-cp src \
	-cp vendor \
	-swf-version 11.8 \
	-swf-header 512:384:60:000000 \
	-main Startup \
	-swf game.swf \
	-swf-lib vendor/starling_1_6.swc --macro "patchTypes('vendor/starling.patch')" \
	-swf-lib vendor/pixelFilter.swc --macro "patchTypes('vendor/starling.patch')" \
	-resource assets/GameMap.tmx@map \
	-debug

clean:
	del game.swf


test: game.swf
	$(ADL) -profile mobileDevice -screensize 1024x768:1024x768 game.xml
