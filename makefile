all:
	gpp main.sh -I ./lib -o helloworld.sh
	chmod 755 helloworld.sh

t: 
	gpp ./test/all-test.sh -I ./lib -I ./test -o run-me-test.sh
	chmod 755 run-me-test.sh
	./run-me-test.sh
	rm ./run-me-test.sh
