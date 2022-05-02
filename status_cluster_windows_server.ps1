#nome do cluster
$cluster=$args[0]

$node=0

if((Get-ClusterNode -Name "$cluster").State -notlike "Up"){
    $node=1     
}

$result=0
Get-ClusterResource | ForEach-Object {    
  if($_.State -like "Online"){
    $result=$result+0
  }else{
    $result=$result+1
  }
}

$final=$result+$node
if($result -gt 0){
    Write-Output "Status: No OK"
    Get-ClusterResource | ForEach-Object { Write-Output ("{0} -> {1}" -f $_.Name,$_.State) }
    exit 1 
}else{
    Write-Output "Status: OK"
    exit 0
}
