$ErrorActionPreference = "Stop"
$t=[System.IO.File]::ReadAllText((Resolve-Path 'index.html'),[System.Text.Encoding]::UTF8);

# Replace scan function: from function scan(file){ to btnCam.addEventListener
$startScan = $t.IndexOf('function scan(file){');
$startBtn = $t.IndexOf('btnCam.addEventListener');
if($startScan -lt 0 -or $startBtn -lt 0){ throw "scan or btnCam not found" }
$oldScan = $t.Substring($startScan, $startBtn - $startScan);
$newScan = [System.IO.File]::ReadAllText((Resolve-Path '_scan_simple.js'),[System.Text.Encoding]::UTF8);
$t = $t.Replace($oldScan, $newScan);
"scan replaced OK"

# Also remove the old vote() function if it still exists
$startVote = $t.IndexOf('function vote(runs){');
$startSO = $t.IndexOf('function showOverlay');
if($startVote -gt 0 -and $startSO -gt $startVote){
    $oldVote = $t.Substring($startVote, $startSO - $startVote);
    $t = $t.Replace($oldVote, "");
    "vote removed OK"
} else {
    "vote not found (already removed)"
}

[System.IO.File]::WriteAllText((Resolve-Path 'index.html'),$t,[System.Text.Encoding]::UTF8);
"All done"
