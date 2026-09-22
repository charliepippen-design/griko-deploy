export default function GrikoLogo({ size = 42, className = "brand-logo", ariaHidden = true }) {
  return (
    <div className={`griko-logo-wrapper ${className}`} style={{ width: size, height: size }}>
      <svg
        viewBox="0 0 76 76"
        width={size}
        height={size}
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        aria-hidden={ariaHidden}
        className="griko-logo-svg"
      >
        {/* Sfondo scultoreo con bordo sottile litico */}
        <rect
          x="1"
          y="1"
          width="74"
          height="74"
          rx="16"
          className="logo-bg"
        />

        {/* Asta verticale scultorea (Gamma lapidea ispirata alla pietra leccese) */}
        <path
          d="M23 19H34.5V56H23V19Z"
          className="logo-gamma-stem"
        />

        {/* Braccio orizzontale con raccordo a voluta litica */}
        <path
          d="M34.5 19H53.5C53.5 19 53 29.5 45 31C41.5 31.7 34.5 29 34.5 29V19Z"
          className="logo-gamma-arm"
        />

        {/* Onda di emissione vocale (Pnéuma / respiro della tradizione orale) */}
        <path
          d="M18 39C25 39 31 33 37.5 33C44 33 48.5 36.5 56 36.5"
          className="logo-pneuma-wave"
          strokeWidth="3.2"
          strokeLinecap="round"
        />

        {/* Brace in terracotta accesa (la lingua che resiste nei 9 comuni) */}
        <circle
          cx="53.5"
          cy="20.5"
          r="4.2"
          className="logo-ember"
        />
        <circle
          cx="53.5"
          cy="20.5"
          r="7.5"
          className="logo-ember-glow"
        />
      </svg>
    </div>
  );
}
