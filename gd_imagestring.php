<?php
	$a=imagecreate(100,100);
	$font=imageloadfont("/bin/simsun");
	imagestring($a, $font, 10,10, "q******************************n", 10);
	imagepng($a, "test.png");
?>
