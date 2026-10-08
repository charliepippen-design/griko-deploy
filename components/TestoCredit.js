const CIURI_LICENSE_URL = "https://creativecommons.org/licenses/by-nc/4.0/deed.it";

export default function TestoCredit({ credito, className = "testo-credit" }) {
  if (!credito) return null;

  if (credito.tipo === "ciuri") {
    const fonte = credito.urlFonte ? (
      <a href={credito.urlFonte} target="_blank" rel="noopener noreferrer">
        Ciuri ce Pedì
      </a>
    ) : (
      "Ciuri ce Pedì"
    );
    return (
      <p className={className}>
        Trascrizione e traduzione: Salvatore Tommasi, da {fonte}, licenza{" "}
        <a href={credito.licenzaUrl || CIURI_LICENSE_URL} target="_blank" rel="noopener noreferrer">
          CC BY-NC 4.0
        </a>
        .
      </p>
    );
  }

  if (credito.tipo === "palumbo") {
    return (
      <p className={className}>
        Pubblico dominio: Vito Domenico Palumbo (1854-1918, Calimera).
        {credito.urlFonte ? (
          <>
            {" "}
            Fonte:{" "}
            <a href={credito.urlFonte} target="_blank" rel="noopener noreferrer">
              {credito.urlFonte}
            </a>
          </>
        ) : null}
      </p>
    );
  }

  if (!credito.urlFonte && !credito.etichetta) return null;
  return (
    <p className={className}>
      {credito.urlFonte ? (
        <a href={credito.urlFonte} target="_blank" rel="noopener noreferrer">
          {credito.urlFonte}
        </a>
      ) : (
        "Fonte non indicata"
      )}
      {credito.etichetta ? ` · ${credito.etichetta}` : ""}
    </p>
  );
}
