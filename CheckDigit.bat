<!-- :: Batch section
@echo off
setlocal
for /F "delims=" %%a in ('mshta.exe "%~F0"') do set "HTAreply=%%a"
echo End of HTA window, reply: "%HTAreply%"
goto :EOF
-->


<HTML>
<HEAD>
<HTA:APPLICATION SCROLL="no" SYSMENU="no" WINDOWSTATE="minimised">

<TITLE>LPN Check Digit</TITLE>
<link href="css/style.css" rel='stylesheet' type='text/css'> 
<script type="text/javascript">
window.resizeTo(600,375);
function luhn_checksum(code) {
    var len = code.length
    var parity = len % 2
    var sum = 0
    for (var i = len-1; i >= 0; i--) {
        var d = parseInt(code.charAt(i))
        if (i % 2 == parity) { d *= 2 }
        if (d > 9) { d -= 9 }
        sum += d
    }
    return sum % 10
}

/* luhn_caclulate
 * Return a full code (including check digit), from the specified partial code (without check digit).
 */
function luhn_caclulate(partcode) {
    var checksum = luhn_checksum(partcode + "0")
    return checksum == 0 ? 0 : 10 - checksum
}

/* luhn_validate
 * Return true if specified code (with check digit) is valid.
 */
function luhn_validate(fullcode) {
    return luhn_checksum(fullcode) == 0
}
    function onChange() {
        var partcode = document.form1.partcode.value
        var checkdigit = luhn_caclulate(partcode)
        var fullcode = partcode + checkdigit
        document.form1.checkdigit.value = partcode ? checkdigit : ""
        document.form1.fullcode.value = partcode ? fullcode : ""
    }
	
function closeHTA(reply){
   var fso = new ActiveXObject("Scripting.FileSystemObject");
   fso.GetStandardStream(1).WriteLine(reply);
   window.close();
}

</script>
</HEAD>
<BODY>
<h1> Calculate check digit</h1>
<form name=form1>
    <table>
        <tr>
            <td>LPN <span class=hint>(numbers only)</span></td>
            <td><input type=text name=partcode id=partcode autofocus onChange="onChange()" onKeyUp="onChange()"></td>
            <td class=hint>without check digit</td>
        </tr>
        <tr>
            <td>Check digit</td>
            <td><input type=text name=checkdigit id=checkdigit readonly size=1></td>
        </tr>
        <tr>
            <td>Full code</td>
            <td><input type=text name=fullcode id=fullcode readonly></td>
            <td class=hint>with trailing check digit</td>
        </tr>
    </table>
</form>
<!-- <button onclick="copyToClipboard('#fullcode readonly')">Copy</button> -->
<button onclick="closeHTA(1);">exit</button>

</BODY>
</HTML>
