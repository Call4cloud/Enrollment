$acl = Get-ACL "C:\Users\Public\Desktop"    
$rule=new-object System.Security.AccessControl.FileSystemAccessRule ("iedereen","FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")    
$acl.SetAccessRule($rule)    
Set-ACL "C:\Users\Public\Desktop" $acl
