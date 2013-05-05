Yet another queuing server. One queue per client connection. The queue is created when a client connects and is destroyed when the client disconnects. The server handles multiple simultaneous client connections.

Implemented as pain-text protocol

	enqueue
		command: in <<the payload>> | ok

	dequeue
		command: out | payload | empty_queue

	All non recognized requests will be rejected as bad_request

Camera, action!

	Start the messaging server
	./start.sh

	Eshell V5.10.1  (abort with ^G)
	1> waiting for conections ...


	Start the clinet

	rsln@ubuntu:~$ telnet localhost 9000
	Trying 127.0.0.1...
	Connected to localhost.
	Escape character is '^]'.

	Client: enque "a"
	in a
	ok

	Client: deque 
	out
	"a"

