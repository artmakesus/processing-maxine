PROCESSING=/home/jacky/Downloads/processing

linux: com_artmakesus_maxine_Maxine.cpp com_artmakesus_maxine_Maxine.h
	javac -d . com/artmakesus/maxine/*.java -cp $(JAVA_HOME)/jre/lib/rt.jar:$(PROCESSING)/core/library/core.jar
	jar -cf maxine.jar com
	g++ *.cpp -lrt -shared -fPIC -o libMaxine.so -I $(JAVA_HOME)/include
	mkdir -p maxine/library
	mv maxine.jar libMaxine.so maxine/library

clean:
	@-rm -r maxine com/artmakesus/maxine/*.class 2> /dev/null || true
