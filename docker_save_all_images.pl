#!/usr/bin/perl
open(PIPE, "docker images |")  or die("usage:   docker images error \n");
for(<PIPE>)
{

    @array=split(/\s+/,$_);
    $raw=$array[0];
    $name=$array[0];
    $tag=$array[1];
    next if($name=~/none/);
    next if($name=~/127.0.0.1/);

    $name=~s/\//_/g;


    print "\n\n#".$name."|\n";
    print "docker  save  $raw:$tag |gzip  >   ${name}_TAG_$tag.tar.gz \n";
    print "docker  load -i   ${name}_TAG_$tag.tar.gz   \n";

}

__DATA__
[root@gresrv bin]# docker images
REPOSITORY                                             TAG                 IMAGE ID            CREATED             SIZE
<none>                                                 <none>              1728b20672ae        18 minutes ago      619.2 MB
tailong                                                4444                10d1a098d5bd        41 minutes ago      309.3 MB
<none>                                                 <none>              8c6259d3ae27        45 minutes ago      309.3 MB
<none>                                                 <none>              358c1d73f497        58 minutes ago      309.3 MB
docker.io/sameersbn/postgresql                         9.4-21              8aba3e293913        7 months ago        231.3 MB
docker.io/tutum/ubuntu                                 trusty              67576a52dd64        8 months ago        251.6 MB
127.0.0.1:5001/docker.io/tobegit3hub/keystone_docker   latest              2f3f1b4cfe24        13 months ago       581.8 MB
docker.io/tobegit3hub/keystone_docker                  latest              2f3f1b4cfe24        13 months ago       581.8 MB

