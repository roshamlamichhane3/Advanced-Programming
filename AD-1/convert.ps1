$files = Get-ChildItem -Path "c:\Users\HP\OneDrive\Documents\Desktop\AD-1\src\main\java" -Recurse -Filter *.java
foreach ($f in $files) {
    $content = Get-Content $f.FullName
    $content = $content -replace 'javax.servlet', 'jakarta.servlet'
    Set-Content $f.FullName $content
}
