#include "com_artmakesus_maxine_Maxine.h"

#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>

JNIEXPORT void JNICALL Java_com_artmakesus_maxine_Maxine_setTexturePixels
  (JNIEnv *env, jobject obj, jint id, jintArray jpixels)
{
	if (!jpixels) {
		return;
	}

	char str[64];
	sprintf(str, "%d", id);

	// Open Shared Memory
	int fd = shm_open(str, O_CREAT | O_RDWR, 0600);
	if (fd == -1) {
		return;
	}

	const jsize len = env->GetArrayLength(jpixels);
	const jint *pixels = env->GetIntArrayElements(jpixels, NULL);

	// Map Pixels
	jint *mpixels = (jint *) mmap(NULL, len * sizeof(*pixels), PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (mpixels == MAP_FAILED) {
		shm_unlink(str);
		return;
	}

	// Copy Pixels
	fprintf(stderr, "BEGIN\n");
	for (jsize i = 0; i < len; i++) {
		mpixels[i] = pixels[i];
	}
	fprintf(stderr, "END\n");
}
