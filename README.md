# Azure Storage — Blob Container + SAS Token Demo

Small Terraform project demonstrating time-limited, scoped access to private blob storage in Azure — no public exposure, no shared account keys handed out, just a signed URL valid for a defined window.

## What it does

- Creates a Storage Account + a **private** Blob Container (`container_access_type = "private"` — no public access by default)
- Uploads a sample file as a block blob
- Generates a **SAS (Shared Access Signature) token** scoped to the container, with explicit permissions (`read` + `list` only — no write/delete) and a fixed validity window
- Outputs a signed URL that grants access *only* while the token is valid, with *only* the permissions explicitly granted

## Verified

- Accessing the blob via the SAS URL → **succeeds**
- Accessing the same blob via the plain URL (no token) → **blocked** (container is private)

This confirms the container has no public exposure, and the SAS token is the only valid access path — exactly the intended behavior.

## Why this matters (AZ-104 relevance)

Storage Account access control, Blob Container access levels, and SAS tokens (account-level vs. container-level vs. blob-level SAS, permissions, expiry) are core AZ-104 topics. This is a minimal, hands-on example of granting scoped, temporary access instead of sharing account keys or making a container public.

## Run it

```bash
az login
terraform init
terraform apply
terraform output sas_url   # sensitive — must be requested explicitly
terraform destroy          # clean up when done
```