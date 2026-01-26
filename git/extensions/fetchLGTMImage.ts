import { sample } from "jsr:@std/collections";

const res = await fetch("https://lgtmoon.herokuapp.com/api/images/recent");
const json = await res.json();
const image = sample(json.images);
if (image !== null && typeof image === "object" && "url" in image) {
  console.log(`![LGTM](${image.url})`);
} else {
  Deno.exit(1);
}
