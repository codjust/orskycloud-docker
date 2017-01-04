<!DOCTYPE html>
<html>
<head>
	<title>Test</title>
</head>
<body>
<pre>
</pre>
{{str2html .URL}}
<a href = '{{.URL2}}'>aa</a>
<a href = '{{htmlunquote .URL3}}'>bbbbbb</a>
<table  id="table-log"
        data-url="{{str2html .URL}}"
        data-url="{{.URL2}}"
        data-toggle="{{str2html .URL}}"
 >
    <thead>
    <tr>
        <th data-field="{{str2html .URL}}">Date</th>
        <th data-field="mail_sender">Mail Sender</th>
        <th data-field="trans_type">Trans Type</th>
        <th data-field="md5">MD5</th>
    </tr>
    </thead>
</table>
</body>
</html>