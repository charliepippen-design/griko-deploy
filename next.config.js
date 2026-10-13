const nextConfig = {
  reactStrictMode: true,
  async redirects() {
    return [
      {
        source: "/approfondimenti/vito-domenico-palumbo",
        destination: "/persone/vito-domenico-palumbo",
        permanent: true,
      },
      {
        source: "/impara",
        destination: "/dizionario",
        permanent: true,
      },
    ];
  },
};
module.exports = nextConfig;
