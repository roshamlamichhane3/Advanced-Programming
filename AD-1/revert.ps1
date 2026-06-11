$files = Get-ChildItem -Path "c:\Users\HP\OneDrive\Documents\Desktop\AD-1\src\main\java" -Recurse -Filter *.java
foreach ($f in $files) {
    $content = Get-Content $f.FullName
    $content = $content -replace 'jakarta.servlet', 'javax.servlet'
    Set-Content $f.FullName $content
}
