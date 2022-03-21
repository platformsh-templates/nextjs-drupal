// This package in its original form can be found at https://github.com/shadcn/next-drupal-debug. 
//  The only changes have been to use environment variables to retrieve the test parameters, 
//  which makes it easier to run this check across environments on Platform.sh.
import fetch from "node-fetch"

const NEXT_PUBLIC_DRUPAL_BASE_URL = process.env.NEXT_PUBLIC_DRUPAL_BASE_URL;
const DRUPAL_CLIENT_ID = process.env.DRUPAL_CLIENT_ID;
const DRUPAL_CLIENT_SECRET = process.env.DRUPAL_CLIENT_SECRET

const basic = Buffer.from(
  `${DRUPAL_CLIENT_ID}:${DRUPAL_CLIENT_SECRET}`
).toString("base64")

fetch(`${NEXT_PUBLIC_DRUPAL_BASE_URL}/oauth/token`, {
  method: "POST",
  headers: {
    Authorization: `Basic ${basic}`,
    "Content-Type": "application/x-www-form-urlencoded",
  },
  body: `grant_type=client_credentials`,
}).then((response) => {
  if (response.status === 200) {
    return console.log("✅ Connection established.")
  }

  console.error("❌", response.statusText)
  console.error(response)
})
