PROCESSING=/home/jacky/Downloads/processing
JAVAC_FLAGS=-d . -cp $(JAVA_HOME)/jre/lib/rt.jar:$(PROCESSING)/core/library/core.jar
JAVA_FILES=com/artmakesus/maxine/*.java
CC_FLAGS=-lrt -shared -fPIC -I $(JAVA_HOME)/include
CC_FILES=com_artmakesus_maxine_Maxine.cpp com_artmakesus_maxine_Maxine.h
OUTPUT_LIBRARY_PATH=maxine/library

all:
	@echo "Please specify your OS [e.g. linux, macosx, windows]"

linux: $(CC_FILES)
	javac $(JAVAC_FLAGS) $(JAVA_FILES)
	jar -cf maxine.jar com
	g++ *.cpp -o libMaxine.so $(CC_FLAGS)
	mv maxine.jar libMaxine.so $(OUTPUT_LIBRARY_PATH)

macosx: $(CC_FILES)
	javac $(JAVAC_FLAGS) $(JAVA_FILES)
	jar -cf maxine.jar com
	g++ *.cpp -o libMaxine.jnilib $(CC_FLAGS)
	mv maxine.jar libMaxine.jnilib $(OUTPUT_LIBRARY_PATH)

windows: $(CC_FILES)
	javac $(JAVAC_FLAGS) $(JAVA_FILES)
	jar -cf maxine.jar com
	g++ *.cpp -o Maxine.dll $(CC_FLAGS)
	mv maxine.jar Maxine.dll $(OUTPUT_LIBRARY_PATH)

clean:
	@-rm -r $(OUTPUT_LIBRARY_PATH)/*.jar $(OUTPUT_LIBRARY_PATH)/*.so com/artmakesus/maxine/*.class 2> /dev/null || true
