# next-drupal-debug
Debug `next-drupal` OAuth connection.

## Steps

1. `git clone https://github.com/shadcn/next-drupal-debug.git`
2. Update the following values in `index.js`:
  - NEXT_PUBLIC_DRUPAL_BASE_URL
  - DRUPAL_CLIENT_ID
  - DRUPAL_CLIENT_SECRET
3. Run `yarn debug`

If you see `✅ Connection established.`, then you have successfully set up the Drupal OAuth consumer.

If you see an error, check your Drupal logs for error messages.
