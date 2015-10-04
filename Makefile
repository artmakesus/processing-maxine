PROCESSING=/home/jacky/Downloads/processing
JAVAC_FLAGS=-d . -cp $(JAVA_HOME)/jre/lib/rt.jar:$(PROCESSING)/core/library/core.jar
JAVA_FILES=com/artmakesus/maxine/*.java
CC_FLAGS=-lrt -shared -fPIC -I $(JAVA_HOME)/include
CC_FILES=com_artmakesus_maxine_Maxine.cpp com_artmakesus_maxine_Maxine.h
OUTPUT_LIBRARY_PATH=maxine/library

linux: $(CC_FILES)
	javac $(JAVAC_FLAGS) $(JAVA_FILES)
	jar -cf maxine.jar com
	g++ *.cpp -o libMaxine.so $(CC_FLAGS)
	mv maxine.jar libMaxine.so $(OUTPUT_LIBRARY_PATH)

linux64: $(CC_FILES)
	javac $(JAVAC_FLAGS) $(JAVA_FILES)
	jar -cf maxine.jar com
	g++ *.cpp -o libMaxine.so $(CC_FLAGS)
	mv maxine.jar libMaxine.so $(OUTPUT_LIBRARY_PATH)

clean:
	@-rm -r $(OUTPUT_LIBRARY_PATH)/*.jar $(OUTPUT_LIBRARY_PATH)/*.so com/artmakesus/maxine/*.class 2> /dev/null || true
