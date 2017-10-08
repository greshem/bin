#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#text()
$("#btn1").click(function(){
  alert("Text: " + $("#test").text());
});

#html()
$("#btn2").click(function(){
  alert("HTML: " + $("#test").html());
});

#val()
$("#btn1").click(function(){
  alert("Value: " + $("#test").val());
});

#attr
$("button").click(function(){
  alert($("#w3s").attr("href"));
});


