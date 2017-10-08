#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}

__DATA__
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="">
        <meta name="author" content="">
        <script src="http://cdn.bootcss.com/jquery/2.2.3/jquery.js" type="text/javascript"></script>
        <link href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container">
            <div class="page-header">
            <h1>Django CRUD Scaffold</h1>
            <p>Default template for generated CRUD scaffold.  You should create your own base.html in your template root, with a block named "content".</p>
            <ul>            
                <li><a href="#">List</a></li>
                <li><a href="#">Create</a></li>
            </ul>
            </div>
            <div class="content">
            content
            </div>
        </div>
    </body>
</html>  

