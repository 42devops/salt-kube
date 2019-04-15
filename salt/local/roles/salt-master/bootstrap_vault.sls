vault_policies:
  vault.policy_present:
    - name: salt-master
    - rules: |
        path "auth/*" {
          capabilities = ["read", "list", "sudo", "create", "update", "delete"]
        }

vault_policies:
  vault.policy_present:
    - name: saltstack/minions
    - rules: |
        path "secret/*" {
        capabilities = ["read", "list"]
        }

        path "auth/*" {
        capabilities = ["read", "list","sudo","create","update","delete"]
        }