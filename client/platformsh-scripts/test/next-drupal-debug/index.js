import fetch from "node-fetch"

const NEXT_PUBLIC_DRUPAL_BASE_URL = "https://api.pr-1-djjnuwy-65o73exizvbli.eu-3.platformsh.site"
const DRUPAL_CLIENT_ID = "1b98aa27-c9d1-4366-88cf-823e796061a3"
const DRUPAL_CLIENT_SECRET = "WXNKNJNF26GLM5Q3VZB56Y4SUZOVXPCEZUXKBSQ7VJESHT67FELA===="

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
