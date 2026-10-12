// Schede biografiche pubblicate sotto /persone invece che /approfondimenti.

export const PERSONE_SLUGS = ["vito-domenico-palumbo"];

export function articlePath(slug) {
  return PERSONE_SLUGS.includes(slug) ? `/persone/${slug}` : `/approfondimenti/${slug}`;
}
