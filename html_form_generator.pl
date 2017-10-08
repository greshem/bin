#!/usr/bin/perl
use Template;

if( ! -f "./css/screen.css")
{
	warn("#not in  qianlong web template  dir \n");
}
my $template=Template->new();
@array=qw(name  phone email  msg  amount );
my $vars={
		table=>"form_output",
		fields=>\@array,
		};
       $template->process(\*DATA, $vars )
          || die $template->error();
  



__DATA__
<html>
<!-- generator by  /bin/html_form_generator.pl  -->
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />

<head>
  <title>基本设置页面 </title>
  <link href="./css/base.css" type="text/css" rel="stylesheet" />
  <link href="./css/screen.css" type="text/css" rel="stylesheet" />
  <link href="./css/tabs.css" type="text/css" rel="stylesheet" />
  <script language="javascript" src="./jslib.js"></script>
  <script language="javascript" src="./js/jquery.js"></script> 
</head>


<body>

<form name="form1" method="post" action="[%table%]_modify_ok.php" onSubmit="return checkadd()">

<h3>test</h3>
  <div style="width: 640; padding: 5px 30px 20px 15px; text-align: left;">
  <table width="50%" border="0" cellspacing="1" cellpadding="3" align="center">
  <tbody>
    <tr> 
      <th colspan="2">[%table%]修改</th>
    </tr>
	
    [% FOREACH field IN fields%]
    <tr> 
      <td width="26%" align="right">[%field%]：</td>
      <td width="74%"> 
        <input name="[%field%]" type="text" value="  [%field%]  " size="50" maxlength="100"   class="textfield" >
      </td>
    </tr>
   [%END%]
    
    
    
    <tr> 
      <td width="26%" align="right"> 
        <!-- <input type="submit" name="Submit" value="提交"> -->
		<input type="button" onclick="PostBack(&quot;SAVE&quot;,&quot;&quot;);" class="mybutton" value="保 存">
      </td>
      <td width="74%"> 
        <!-- <input type="reset" name="Reset" value="重置"> -->
		<input type="button" onclick="PostBack(&quot;SaveAsDefault&quot;,&quot;&quot;);" class="mybutton" value="设置默认">
      </td>
    </tr>
  </tbody>
  </table>
  </div>
</form>
</body>
</html>
