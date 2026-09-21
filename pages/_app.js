import { GoogleTagManager } from "@next/third-parties/google";
import "../styles/globals.css";

export default function App({ Component, pageProps }) {
  return (
    <>
      <GoogleTagManager gtmId="GTM-MSH7BTJ5" />
      <Component {...pageProps} />
    </>
  );
}
