upstream thin{ 
	server 127.0.0.1:3000;
	server 127.0.0.1:3001;
	server 127.0.0.1:3002;
} # itrade

server {
	listen 80;
	server_name localhost;
	
	access_log /home/yuki/Projects/itrade/log/access.log;
	error_log /home/yuki/Projects/itrade/log/error.log;
	
	root   /home/yuki/Projects/itrade/public;
	index  unused.index.html;
	
	try_files $uri/index.html $uri.html $uri @thin;
	
		
	# this prevents hidden files (beginning with a period) from being served
	location ~ /\.          { access_log off; log_not_found off; deny all; }
	
	location = /robots.txt  { access_log off; log_not_found off; }
	location = /favicon.ico { access_log off; log_not_found off; }
	
	location @thin { 
		proxy_set_header  X-Real-IP  $remote_addr;
		proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_redirect off;
		
		proxy_pass http://thin;
	} # proxy to rails
	
} # server
