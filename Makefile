latest: 1.14.0

1.14.0:
	./build.sh "1.14.0"

1.13.0-rewards:
	./build.sh "1.13.0-rewards"

1.13.0:
	./build.sh "1.13.0"

1.12.0:
	./build.sh "1.12.0"

1.11.0:
	./build.sh "1.11.0"

1.10.1:
	./build.sh "1.10.1"

1.10.0:
	./build.sh "1.10.0"

1.9.3:
	./build.sh "1.9.3"

1.9.2:
	./build.sh "1.9.2"

1.9.1:
	./build.sh "1.9.1"

1.9.0:
	./build.sh "1.9.0"

1.8.0:
	./build.sh "1.8.0"

1.7.0:
	./build.sh "1.7.0"

1.6.0:
	./build.sh "1.6.0"

base-image:
	./build-base.sh

base-compile-image: base-image 
	./build-base-compiler.sh "8.6.5" "3.2.0.0"
