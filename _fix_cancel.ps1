$ErrorActionPreference = "Stop"
$t=[System.IO.File]::ReadAllText((Resolve-Path 'index.html'),[System.Text.Encoding]::UTF8);

$marker = 'scanApply").addEventListener("click", function(){';
$i = $t.IndexOf($marker);
if($i -lt 0){ throw "marker not found" }

# Find the end of this handler - look for the next }); followed by blank line and $("#scanRetry
$start = $i;
# Find end of this function block
$endMarker = "  });`n`n  $("#scanRetry";
$j = $t.IndexOf($endMarker, $start);
if($j -lt 0){ 
    # Try alternate
    $endMarker2 = "  });`n`n$("#scanRetry";
    $j = $t.IndexOf($endMarker2, $start);
    if($j -lt 0){ throw "end marker not found"; $endBlock = $t.Substring($start, 500); "END BLOCK:"; $endBlock }
}
$end = $j + $endMarker.Length;

$oldBlock = $t.Substring($start, $end - $start);

$newBlock = @'
scanApply").addEventListener("click", function(){
    if(!current) return;
    var sel = document.querySelector('input[name="cand"]:checked');
    if(sel) current = sel.value;
    vin.value = current;
    vin.dispatchEvent(new Event("input", { bubbles: true }));
    vin.dispatchEvent(new Event("change", { bubbles: true }));
    $("#scanModal").classList.remove("on");
    current = "";
    toast("VIN подставлен — проверьте символы");
    vin.focus();
    try{ vin.setSelectionRange(0, vin.value.length); }catch(e){}
  });

  $("#scanCancel").addEventListener("click", function(){
    current = "";
    $("#scanModal").classList.remove("on");
    toast("Отменено");
  });

  $("#scanRetry';
'@

$t = $t.Replace($oldBlock, $newBlock);
[System.IO.File]::WriteAllText((Resolve-Path 'index.html'),$t,[System.Text.Encoding]::UTF8);
"scanCancel handler added OK"
