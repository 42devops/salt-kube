path "secret/*" {
capabilities = ["read", "list"]
}

path "auth/*" {
capabilities = ["read", "list","sudo","create","update","delete"]
}