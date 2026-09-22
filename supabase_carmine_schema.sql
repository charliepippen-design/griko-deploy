-- ==============================================================================
-- Schema Supabase per il Corso Grammaticale e Canti di Carmine Greco
-- 28 lezioni (24 di grammatica sistematica + 4 canti/poesie tradizionali)
-- ==============================================================================

CREATE TABLE IF NOT EXISTS public.carmine_greco_lessons (
    id SERIAL PRIMARY KEY,
    ordine INTEGER NOT NULL UNIQUE,
    video_id TEXT NOT NULL UNIQUE,
    titolo TEXT NOT NULL,
    categoria TEXT NOT NULL,
    categoria_label TEXT NOT NULL,
    durata TEXT NOT NULL,
    conteggio_parole INTEGER NOT NULL,
    sommario TEXT NOT NULL,
    proverbio_chiave TEXT,
    trascrizione TEXT NOT NULL,
    is_poetry BOOLEAN NOT NULL DEFAULT FALSE,
    creato_il TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_carmine_categoria ON public.carmine_greco_lessons (categoria);
CREATE INDEX IF NOT EXISTS idx_carmine_ordine ON public.carmine_greco_lessons (ordine);

-- Policy di lettura pubblica (RLS)
ALTER TABLE public.carmine_greco_lessons ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public read on carmine_greco_lessons" ON public.carmine_greco_lessons;
CREATE POLICY "Allow public read on carmine_greco_lessons"
    ON public.carmine_greco_lessons FOR SELECT
    TO public
    USING (true);

-- Inserimento o aggiornamento idempotente (ON CONFLICT)
INSERT INTO public.carmine_greco_lessons (
    ordine, video_id, titolo, categoria, categoria_label, durata, conteggio_parole, sommario, proverbio_chiave, trascrizione, is_poetry
)
VALUES
(1, 'WlpRcf-8zmo', 'L''Alfabeto e la Grafia del Griko', 'fonetica', 'Fonetica & Alfabeto', '09:10', 899, 'Introduzione ai fondamenti fonetici e al sistema di scrittura della lingua grica basato sui caratteri latini. Carmine Greco spiega la resa grafica dei suoni gutturali, palatali e sibilanti peculiari del Salento ellenofono.', '«I glossa ma ''en eni pràma chariatiko, ma en i kardìa ma» — La nostra lingua non è cosa rozza: è il nostro cuore.', 'a tutti la lezione che qui andremo a
trattare riguarda l''alfabeto da usare
per la scrittura della lingua grica
questa è la prima di una serie di
lezioni rivolte a chi è interessato o ad
apprendere o ad approfondire una lingua
che vanta origini antichissime
secondo alcuni studiosi essa affonda le
proprie origini nella colonizzazione
della magna grecia del vii secolo avanti
cristo ad opera di coloni tenuti qui
dalla grecia
il grido è parlato ancora oggi da un
ristretto numero di persone per lo più
anziane nell''area e le norma che prende
il nome di crisi a salentina poi perché
nell''area calabrese intorno a provare
purtroppo il griko va gradualmente
scomparendo
perché non viene più trasmesso alle
nuove generazioni all''interno delle
famiglie per cui c''è il rischio di una
sua reale estensione a breve termine in
alcuni paesi della grecìa salentina
come sapete a melpignano l''uso della
lingua grika e del tutto scomparso
pertanto queste nostre lezioni mirano a
dare una nuova linfa vitale a questo
idioma che contiene in sé pensate un po
termini usati anche da omero nell''iliade
e nell odissea
in questa nostra prima lezione ci
limiteremo a dare delle indicazioni
circa l''alfabeto da usare per la
scrittura del greco
come possiamo vedere dalla tabella
praticamente le lettere con cui si
scrive il griko sono sostanzialmente
quelle italiane con alcune avvertenze
che vedremo allora per quanto riguarda
la la b non ci sono problemi sono si
pronunciano come in italiano per quanto
riguarda la ci abbiamo anche in italiano
due città chip a natale e l''aci
culturale facci palatale che proviamo
nella parola cena italiana a cena o
cinema detta palatale lacci perché viene
pronunciata appoggiando la lingua sul
palato e la città natale la proviamo
nelle parole griglie sociali testa sin
urge che significa un nuovo i sì che
significa li citrino che significa
giallo calo ieri estate eccetera
la strutturale che proviamo nelle parole
italiane casa chiesa e troviamo anche
nelle parole grigie cardia cotto dio
taglio cardia cuore cotto io taglio a
chi atera ragazza finita
che significa partita che ci piccolo e
da tante altre ma possiamo rendere il
cre modi davanti alla alloro e alla v
possiamo renderla semplicemente con
lacci davanti alla i e d''anna e possiamo
vendere col ch in alternativa possiamo
usare il k
in entrambi i casi davanti alla lola
oppure davanti alla i e alla e vediamo
un po
c''è un altro suono in riva che è la c
aspirata la sea si viene pronunciata
posizi che troviamo nelle parole suoni
neve figlie mille correo io ballo cristo
cristo eccetera
come renderla qui ci sono diverse
ipotesi che diciamo
studia il grido scrive diciamo che ci
sono delle ipotesi contrastanti e
diverse
vediamo come quale lettera usare allora
si può rendere la c aspirata si può
rendere col ch però se noi usiamo il ch
e nelle parole vere esempio azioni
figlie correva eccetera
davanti a parole come matera con
culturale finita che ci possiamo più
usare che ch
altrimenti leggeremo aspirato e non
sarebbe corretto quindi se noi optiamo
per il ch per prendere l''aspirazione del
c aggiungendo l''h davanti alla c
praticamente abbiamo poi scrivere la c
bruttura le col k se invece optiamo per
l''aspirazione vogliamo rendere
l''aspirazione aggiungendo alla calati al
k oppure più semplicemente con lucky
greca o con l''acca semplicemente poi la
cigo tra le lac ma possiamo rendere poco
a poco ch davanti a sé alla iella è poco
al cup
l''atc semplicemente davanti alla lotta
per quanto riguarda le altre lettere non
ci sono grossi problemi
vediamo un po la di laera e con in
italiano
abbiamo un altro suono in rito che
corrisponde al i semi vocalità o semi
consonanti che se preferite che troviamo
nella parola il juventus idiota e in
italiano e in griko nelle parole pieno
biglietti significa la gente io e
significare iso idioti che significa
perché i chi nega eccetera
un altro supporto per quanto riguarda
abbiamo il klm n8 con la q di quadra una
passione under anche con pek volendo e
poi un altro sono particolare e la z z
in italiano abbiamo due tipi di sera
come sappiamo la il senatore cielo
sonora di zona zaino che troviamo nelle
parole greek and joy sim o no della rai
vita simone impasto della significa
testa calva
e poi abbiamo in italiano il z as pravo
sorda che la doppia z di pozzo
so che viene pronunciato così è che
dovremmo rendere preferibilmente con il
ts è però proviamo nelle parole sogni 0
seno sì lo so mi pane 0 io so se no
forestiero silo legno eccetera perché
volti s perché purtroppo la doppia z
anche in italiano viene pronunciata in
maniera diversa a seconda delle diverse
regioni
io sento spesso in televisione dire
azzardo
qui da noi si pronuncerebbe azzardo il
giovane hazard invece spesso viene
pronunciata azzardo
oppure anziché il razzo si pronuncia
razzo
il razzo e quindi per non generare
confusione si queste parole greche vanno
pronunciate se da aspra scrivendo doppia
z si potrebbe generare qualche
incertezza o confusione
per quanto riguarda la pronuncia per cui
sarebbe auspicabile scrivere colti sts e
aggiungendo l''avvertenza che il ts
corrisponde alla doppia z di pozzo cioè
all''azienda aspra lo so questo è tutto
spero di essere stato chiaro
vi saluto e vi do appuntamento alla
prossima menzione', FALSE),
(2, 'sifVb8H8EvM', 'L''Articolo Determinativo Singolare', 'nomi', 'Morfologia Nominale', '21:28', 1571, 'Analisi approfondita dell''articolo determinativo singolare nei tre generi (maschile ''o'', femminile ''i'', neutro ''to'') e nei casi nominativo e accusativo/genitivo. Focus su elisioni e assimilazioni prima di vocale.', '«O chierò chieri fèrni» — Il tempo porta la stagione opportuna (ogni cosa ha il suo tempo).', 'ciao a tutti in questa lezione parleremo
dell''articolo determinativo in griko e
del suo uso come sapete in italiano
all''articolo accompagna il nome
seguendolo e lo stesso genere e numero
perciò può essere articolo maschile o
femminile singolare plurale
lo stesso avviene in griko tuttavia con
qualche differenza
osservando la tabella di world una prima
differenza salta evidente agli occhi il
griko oltre al genere maschile e
femminile maschile femminile anche il
genere neutro
inoltre in italiano l''articolo
determinativo si usa solo per i casi
diretti cioè quando il nome che
accompagna tra da soggetto o complemento
oggetto mentre per i complementi
indiretti di specificazione di termine
si ricorre a delle proposizioni semplici
o articolate in griko invece come
d''altronde dal greco antico e nel greco
moderno
l''articolo segue una sua declinazione
che cambia a seconda della sua funzione
logica pertanto diamo uno sguardo alla
tabella quindi abbiamo in griko
l''articolo o se il nome che accompagna
fa da soggetto l''articolo tu se il nome
che accompagnata da complemento di
specificazione o di termine
l''articolo ton che può subire anche il
cro camento della n in alcuni casi come
vedremo se il nome che accompagna fa da
complemento oggetto
qual è la traduzione articolo logica 2
cioè con il no perché un caso diretto
l''articolo tu si traduce con delle
preposizioni semplici o articolate di
del bello se complemento di
specificazione si traduce con a alla
fallo se è un complemento di termine
passiamo al femminile abbiamo per il
soggetto la iii per il complemento di
specificazione e di termine tease in che
può subire anche in questo caso
toccamento in alcuni casi se il nome che
accompagna è un complemento oggetto si
traduce così e si traduce la keys di
della se il complemento di
specificazione a alla se è un
complemento di termine la se un
complemento oggetto
passiamo adesso al neutro il neuro top
in griko per il soggetto se fa da
soggetto il lo si traduce in italiano
poi abbiamo il tuo in griko se è un
complemento di specificazione o di
termine che si produce di del bello a
all hallow eto''o che si può anche
apostrofare posso dire l''elisione in
questo caso si dice visione non
pronunciamento se il nome che accompagna
è un complemento oggetto
naturalmente mi potreste chiedere e
giustamente cosa significa soggetto
complemento oggetto di specificazione
allora somma delle elementari nozioni di
grammatica che si studiano nella scuola
secondaria di primo grado
quella che si chiamava scuola media ma
che forse per qualcuno sono cadute nel
dimenticatoio
perciò cercheremo di rinverdirla un po
con gli esempi che seguono innanzitutto
diciamo che il soggetto è quella persona
animale o cosa che compie l''azione e
risponde alla domanda chi che cosa il
complemento di specificazione risponde
alla domanda di chi di che cosa il
complemento di termine risponde alla
domanda a chi
a che cosa il complemento oggetto è il
complemento che riceve l''azione compiuta
dal soggetto ora osserviamo gli esempi
per il maschile abbiamo la seguente
frase quando l''articolo fa da soggetto
opaco o cui ci seppi mio nonno si chiama
giuseppe letteralmente sarebbe il nonno
mio si chiama giuseppe come vediamo in
questa frase abbiamo usato un articolo o
perché mio nonno opa como
mio nonno fa dal soggetto passiamo alla
frase seguente o giacco to papu e ne
mabro la giacca del nonno e nera vediamo
in questa frase abbiamo usato l''articolo
tu perché del nonno è un complemento di
specificazione risponde alla domanda di
chi del nonno
vediamo la casa enna dopo to sordo to
scarpari devo dare i soldi al calzolaio
a chi al calzolaio al calzolaio quindi è
un complemento di termine
abbiamo usato anche in questo caso
l''articolo determinativo maschile
singolare tu al ca frase è da top a como
vidi mio nonno letteralmente il nonno
mio
abbiamo usato l''articolo top perché è un
complemento oggetto io compio l''azione
del vedere
e questa azione va a cadere sul
complemento oggetto o omo in questo caso
non abbiamo pronunciato né scritto la n
perché la parola che segue l''articolo
incomincia per p e quindi in questo caso
non si pronuncia non si scrive la n
vediamo l''altra frase a cappotto nand
ramo amo mio marito letteralmente il
marito mio
abbiamo usato ton che è il l''articolo
del complemento oggetto perché appunto
mio marito fa da complemento oggetto
oggetto io amo chi mio marito
andiamo a vedere qualche frase qualche
esempio per il femminile
allora gli nega tui.it onis e ne asili
la moglie del vicino di casa è alta
abbiamo usato i che è l''articolo
femminile singolare che fa da soggetto
perché appunto gli nega fa da soggetto
chi è alta
chi compie l''azione dell''essere alta la
donna la moglie gli nega
andiamo alla frase da madia keys dinner
camus in onda i capelli di mia moglie
sono corti letteralmente i capelli della
moglie mia sono corti kiss linee che
abbiamo usato tease perché è un
complemento di specificazione
di chi i capelli di chi di mia moglie
allora quarta fase teese maria piace a
netta la qana traduciamo così a maria
piace la verdura a chi a maria
complemento di termine quindi anche qui
come per il complemento di
specificazione abbiamo usato kiss altra
frase per il femminile e da teen
innamorata
ho visto la fidanzata
abbiamo usato team che è l''articolo
femminile complemento progetto perché
appunto la fidanzata fa da complemento
oggetto
io ho visto che la fidanzata
quindi la fidanzata riceve l''azione del
vedere compiuta dal soggetto
io in questo caso team viene scritta è
pronunciata con la n perché la parola
che segue incomincia per vocale
vediamo qualche frase per il neo papà
nieri atic ora stasi a bree la fiera di
sternatia arriva domani panieri è neutro
in griko abbiamo usato l''articolo top
per il soggetto articolato imera to
paniri estate il giorno della fiera è
arrivato tu paniri di che cosa il giorno
di che cosa della fiera complemento di
specificazione abbiamo usato il tool
vediamo altra frase e dica tu per tu
iorgi o nun antar pieni ho dato al
figlio di giorgio un giocattolo tube di
al tiglio ho dato a chi complemento di
termina quindi anche qui abbiamo usato
tu tu che traduce anche il complemento
di termine altra frase hanno resa top e
disse ho conosciuto tuo figlio il
letteralmente il figlio tuo ho
conosciuto chi complemento oggetto il
tuo figlio quindi ho usato toto che è
l''articolo neutro che funge da completo
oggetto vediamo quest''ultima frase con
l''ico roit arnad c il lupo mangia
l''agnello chi mangia il lupo e l''agnello
l''agnello e complemento oggetto abbiamo
usato youth ho scritto questa volta col
costo perché la parola che segue
incomincia per locale bene per questa
lezione tutto e non vi resta che
salutarvi e darvi appuntamento alla
prossima adesione che riguarderà
l''articolo determinativo plurale ciao
ciao
ciao a tutti in questa lezione parleremo
dell''articolo determinativo in griko e
del suo uso come sapete in italiano
all''articolo accompagna il nome
seguendolo e lo stesso genere e numero
perciò può essere articolo maschile o
femminile singolare o plurale
lo stesso avviene in griko tuttavia con
qualche differenza
osservando la tabella di world una prima
differenza salta evidente agli occhi il
griko oltre al genere maschile e
femminile maschile femminile anche il
genere neutro
inoltre in italiano l''articolo
determinativo si usa solo per i casi
diretti cioè quando il nome che
accompagna fa da soggetto o complemento
oggetto mentre per i complementi
indiretti di specificazione di termine
si ricorre a delle proposizioni semplici
o articolate in griko invece come
d''altronde dal greco antico e nel greco
moderno
l''articolo segue una sua declinazione e
cambia a seconda della sua funzione
logica pertanto diamo uno sguardo alla
tabella quindi abbiamo in griko
l''articolo o se il nome che accompagna
fa da soggetto l''articolo tu se il nome
che accompagnata da complemento di
specificazione o di termine
l''articolo ton che può subire anche il
cro camento della n in alcuni casi come
vedremo se il nome che accompagna fa da
complemento oggetto
qual è la traduzione articolo logica 2
cioè con il no perché un caso diretto
l''articolato si traduce con delle
preposizioni semplici o articolate di
del bello se complemento di
specificazione si traduce con a alla
fallo se è un complemento di termine
passiamo al femminile
abbiamo per il soggetto la iii per il
complemento di specificazione e di
termine tease in che posso dire anche in
questo caso il trattamento in alcuni
casi se il nome che accompagna è un
complemento oggetto si traduce così e si
traduce la keys di della se il
complemento di specificazione a alla se
è un complemento di termine la se un
complemento oggetto
passiamo adesso al neutro il neuro è in
griko per il soggetto se fa da soggetto
il lo si traduce in italiano
poi abbiamo il tuo in griko se è un
complemento di specificazione o di
termine che si produce di del bello a
all hallow eto''o che si può anche
apostrofare posso dire l''elisione in
questo caso si dice visione non
pronunciamento se il nome che accompagna
è un complemento oggetto
adesso passiamo a vedere alcuni esempi
per il maschile opa omu cui ci seppi
bene per questa lezione tutto e non vi
resta che salutarvi e darvi appuntamento
alla prossima adesione che riguarderà
l''articolo determinativo plurale ciao
ciao', FALSE),
(3, 'e2LjR6CoOG0', 'L''Articolo Determinativo Plurale', 'nomi', 'Morfologia Nominale', '10:16', 828, 'Regole di flessione dell''articolo plurale per maschile (''i''), femminile (''e'') e neutro (''ta''). Dettagliate le concordanze con i sostantivi plurali e i fenomeni di troncamento fonosintattico nel parlato.', '«I kalì kumpagnìa kàmni to kumpàgno kalò» — La buona compagnia rende migliore il compagno.', 'cari amici buongiorno in questa lezione
che il proseguimento della precedente
nella quale abbiamo parlato
dell''articolo determinativo singolare
tratteremo il plurale dello stesso
articolo determinativo tengo a precisare
che una lingua non si apprende
memorizzando schemi e regole
grammaticali o perlomeno servono
sicuramente anch''esse altrimenti non
saremmo qui a mostrarvi schemi tabelle e
regole tuttavia per imparare a parlare
una lingua
occorre viverla cioè bisogna cominciare
a usarla nella vita quotidiana ai
rapporti interpersonali e questo i
nostri paesini della grecìa salentina è
ancora possibile in quanto ci sono
persone che conoscono e parlano il griko
il metodo che personalmente ritengo
valido è quello di memorizzare le frasi
che riportiamo come esempi alle regole e
ricavare la regola da s giusto per fare
un esempio se memorizziamo la frase
toste dio piace e oneta glitch e ata e
sappiamo che significa ai ragazzi
piacciono i dolci di conseguenza abbiamo
capito è sicuramente ricorderemo che hai
si traduce tos prima di analizzare il
maschile femminile e neutro
dell''articolo determinativo plurale
ricapitoliamo un attimo cosa significa
soggetto complemento di specificazione
di termine e complemento al 100 il
soggetto risponde alla domanda chi che
cosa ed è quella persona animale o cosa
che compie l''azione il complemento di
specificazione specifica il significato
della parola
da cui dipende esempio il libro di
geografia lì che cosa di geografia
quindi questo è il complemento di
specificazione perché specifica di che
libro si tratta il complemento di
termine indica la persona ad animale o
la cosa su cui va a terminare l''azione
compiuta dal soggetto esempio do un
libro a mario a chi a mario è il
complemento di termine perché a mario va
a terminare l''azione compiuta dal
soggetto io il complemento oggetto detto
anche complemento diretto e la persona
di mario cosa su cui ricade direttamente
cioè senza l''uso di alcun a reposizione
l''azione compiuta dal soggetto ed
espressa dal verbo ad esempio io studio
la lezione che cosa la lezione
l''adesione è l''oggetto del mio studio
prenderemo comunque a parlare di questi
argomenti di analisi logica quando
tratteremo i nomi e gli aggettivi
allora adesso diamo uno sguardo alla
tabella e vediamo quali sono gli
articoli determinativi plurali per il
maschile femminile e neutro
allora se l''articolo fa da soggetto va
in caso nominativo e abbiamo il maschile
e femminile è neutro ma se è un
complemento di specificazione o di
termine abbiamo tos per il maschile
posso per il femminile tos per il neo
seno articolo alla funzione logica di
complemento oggetto va in caso
accusativo e abbiamo tus carina
stile testa per il femminile da per il
neo p come si traducono allora il
maschile plurale e si traduce in
italiano
i fogli il femminile plurale le il neuro
plurale i fogli tos corrisponde all
italiano dei degli se complemento di
specificazione ai tagli se complemento
di termine posso per il femminile si
traduce del o al top per il neutro dei o
degli se è complemento di specificazione
ai tagli se complemento di termine
passiamo adesso al complemento oggetto
che va in caso accusativo tus si traduce
i fogli tess le dà si traduce i fogli
adesso vediamo alcuni esempi primo
esempio per il maschile i papi ma isan e
attechì i nostri nonni erano poveri i
nostri nonni e il soggetto quindi
abbiamo usato l''articolo determinativo
maschile e imera tosap è da meno il
giorno dei defunti
di che cosa complemento di
specificazione quindi abbiamo usato toss
e di che la fame ethos recco ha dato da
mangiare ai maiali a chi complemento di
termina quindi posso
catari se tu largo lo hai portato gli
alberi che cosa gli alberi complemento
oggetto quindi caso accusativo tus
facciamo qualche esempio per il
femminile
e''come bareto stimo e che c''è
le stanze di casa mia sono piccole le
stanze fanno da soggetto quindi abbiamo
usato per il canile di kamber trama di
atos fineco in magre ha i capelli delle
donne sono lunghi gli echi delle donne
complemento di specificazione abbiamo
usato tosto skineco piace i am here is
one o di alle donne piace parlare molto
a chi alle donne complemento di termine
abbiamo usato tos a foras a tessa it gli
athlon argalìo ho comprato le scuole per
il telaio che cosa ha comprato le scuole
tes
facciamo qualche esempio per il neutro
da cofini a indio ma da i panieri sono
pieni i panieri soggetto neutro
abbiamo usato fa oman e cotto macherio
isone a filo il manico
dei coltelli era di legno di chi dica
cosa dei coltelli quindi complemento di
specificazione tos neuro tos pedìo piace
leonetta glitch e ata ai ragazzi
piacciono i dolci a chi ai ragazzi
quindi complemento di termine tos in usa
tafi da tos a ruolo ho raccolto le
foglie degli alberi che cosa ho raccolto
le foglie complemento oggetto va bene
questo è tutto
spero di non avervi annoiato e vi
rimando alla prossima regione ciao a
tutti', FALSE),
(4, 'DSEasnZnTkE', 'Il Nome: Sostantivi Maschili in -o', 'nomi', 'Morfologia Nominale', '19:26', 1624, 'Studio della prima classe dei sostantivi maschili parossitoni e ossitoni terminanti in -o. Illustrazione delle desinenze di caso (nominativo, genitivo, accusativo) e confronto con le radici del greco classico.', '«To ftiachò ''en echi manastiri» — Il povero non ha convento (chi non ha mezzi deve confidare solo nelle proprie forze).', 'benvenuti a questa nuova lezione in cui
tratteremo il nome in tutte le sue forme
come possiamo vedere dallo schema i nomi
in griko possono essere maschili
femminili e neutri
ciò avviene anche in latino e il greco
antico e nel greco moderno dove troviamo
il genere neutro che non troviamo invece
in italiano osserviamo più da vicino lo
schema e notiamo che per ciascun genere
maschile femminile e neutro
ci sono diverse terminazioni cioè il
nome al nominativo singolare che il caso
del soggetto alla desinenza in o in a a
può avere in poi ne poi a seconda del
della sillaba su cui cade l''accento
abbiamo parole spicciole con l''accento
sulla terzultima parole piane con
l''accento sull''ultima e parole tronche
con l''accento sull''ultima i drammatici
quando l''accento cade sulla terzultima
dicono che è una parola prova a rossi
dona a rossi donasse cadere sulla
penultima e o sito ma se cade su
l''ultima sillaba
quindi per quanto riguarda i nomi
maschili
abbiamo sia nomi prova rossi doni siano
mi paro sironi e siano i rossi vani per
quanto riguarda la terminazione i no
per quanto riguarda la desinenza in ha
invece abbiamo solo nomi con l''accento
sulla penultima come patera e per quanto
riguarda la desinenza e ne abbiamo nomi
ugualmente con l''accento sulla penultima
quindi pa rossi fani
mentre per quanto riguarda la desinenza
e ne abbiamo soltanto nomi o si doni
cioè con centro sull''ultima sillaba
passiamo al femminile per femminile
abbiamo la desinenza in a e quindi
abbiamo parole prop arrossito ne fa
rossi de rossi lo re con la desinenza
finale sini e quindi parole con
l''accento che cade sulla terzultima
sillaba sulla penultima e sull''ultima
passiamo al neutro al neuro abbiamo la
desinenza ho sempre del nominativo
singolare stiamo parlando con termini e
che hanno l''accento sulla verso ultima
quindi prova rossi doni sulla penultima
quindi pa rossi tommy sull''ultima quindi
possibili per quanto riguarda la
desinenza in abbiamo soltanto parole con
l''accento sulla penultima e sull''ultima
silva invece per i nomi neutri che hanno
la desinenza in a
abbiamo termini prova rossi toni con
l''accento sulla per tutti ma e paro
sironi con l''accento sull''ultima sila
bene adesso entrando nei dettagli
cominceremo ad analizzare i nomi di
genere maschile femminile neutro a
seconda delle loro desinenze riportando
anche degli opportuni esempi
adesso entreremo nella fase più
interessante e pratica delle lezioni
sulla lingua grica qui in questa
diapositiva incominciamo ad analizzare
il nome maschile che ha la desinenza al
nativo singolare i no innanzitutto
spendiamo qualche parola per chiarire
per ricordare cosa sono le desinenze
allora il nome è costituito da
parte fissa e una parte mobile la parte
fissa che è chiamata anche te ma ora
dice è la parte mobile che è chiamata
desinenza ora vediamo qui per esempio la
parola greca ancre co che significa uomo
al nominativo singolare esce in o alla
desinenza eno
ricordiamo anche che il nominativo è il
caso del soggetto cioè quando un nome
funge da soggetto quando il nome compie
l''azione praticamente alla residenza i
no che la desinenza del nominativo
allora vediamo un po come si declinano
questi nomi abbiamo nomi con l''accento
sulla terzultima come ancre co che
significa uomo abbiamo detto che al
nominativo singolare ha anche co al
nominativo plurale fa en propri poi al
genitivo dativo che sono i casi del
complemento di specificazione e del
complemento di termine anche cosa tu un
crop tos antropo cioè dell''uomo degli
uomini oppure all''uomo agli uomini
poi il caso accusativo che il caso del
complemento oggetto fa don hahn greco
tus antropo poi a questo gruppo di nomi
maschili che hanno la desinenza i no ci
sono nomi che hanno l''accento sulla
penultima come fango e nuovi che hanno
l''accento sull''ultima sillaba adesso
cominciamo a vedere alcuni nomi maschili
che hanno la desinenza i no allora
abbiamo anche co che significa uomo sa
nemo e significa vento
gambaro che significa gambero cantaro
vaso da notte
questi sono nomi che hanno l''accento
sulla terz ultima cioè prova rossi
valico lupo kiko muro cosmo mondo vengo
luna ma oro e significa passaggio parco
questi li cotico cosmo ferro boro anno
l''accento sulla penultima cioè sono
paros i doni sono dolore alla lepre
cannò fumo
metterò suocero c''era tempo sta pro
croce stand o li aspetta
esterna di abbiamo lo stand o rambo
genero tutti questi nomi sono posti doni
cioè anno l''accento sull''ultima sillaba
e adesso alcuni esempi sempre di nomi
maschili terminanti in al nominativo
singolare oa nemo humbel i sette mesi
l''unar culo il vento ha gettato a terra
un albero che cosa ha gettato a terra un
albero un albero e complemento oggetto
quindi vediamo
l''articolo indeterminativo nun è la
desinenza
il complemento oggetto che ho al ghul a
simeri mare o tu scandalo oggi cucino i
gamberi che cosa complemento oggetto
tour campano tus è l''articolo
determinativo accusativo plurale e
cambarau e la desinenza del complemento
oggetto dell''accusa livo plurale da
mattia tosan proprio i con da i capelli
degli uomini sono corti tos antropo di
chi degli uomini complemento di
specificazione caso genitivo plurale
vediamo l''articolo tos che il genitivo
plurale e la che la terminazione del
genio plurale del nome anfra com cam e
tosi ma titus tablò fai il segno della
croce giusta brotto e il genitivo del
dell''articolo determinativo e l''autista
pro e la desinenza del nome spazzare
voluto slip hanno ucciso tutti i lupi
che hanno ucciso tutti i lupi quindi
dico anche qui lusso è l''articolo
dell''accusa tivo la ue e la terminazione
la desinenza lilico desinenza della
arrivo plurale o cosmo e il bisogno a sé
agati il mondo ha bisogno di amore o
cosmo e il soggetto da soggetto e va in
caso nominativo quindi abbiamo la o che
il l''articolo del nominativo singolare e
lo di cosmo che è la desinenza del
nominativo singolare dofus su fango
fosse sinceramente non è una parola
greca una parola neogreca noi diremmo i
luce però insomma siccome fosse è una
parola che proviamo spesso e volentieri
anche in italiano nella parola per
esempio fotografia
io direi di usarla per arricchire un po
anche il lessico drigo allora la luce
della luna tu fango su fango
e il caso del complemento di
specificazione di chi della luna quindi
tu
vengo scelgo io vado significa luna
piena
vengo in questo caso è il nominativo
quindi alla terminazione i no attenzione
al fatto che alcuni nomi in italiano
sono femminili in griko sono maschili
e il caso di fenico in italiano diciamo
la luna in griko fango è un nome
maschile o vengono adesso prendiamo in
esame i nomi maschili che hanno la
desinenza in a al nominativo singolare
allora in questo schema
notiamo subito che come noi maschili in
a
abbiamo solo nomi pa rossi toni cioè con
accento sulla penultima sillaba come per
esempio il nome matera allora vediamo un
po decliniamo un po il nome patera e
significa prete ma significa anche padre
infatti anche in italiano
il crede lo chiamiamo padre allora al
nominativo che il caso del soggetto
abbiamo o patera i poteri
il prete i preti al caso il genitivo ed
arrivo sono i casi del complemento di
specificazione di termine abbiamo quindi
del prete to patera dei preti tous pad
ero al prete to patera ai preti cospa
the row il caso accusativo che caso del
complemento al ceto abbiamo tom patera
il prete giusta theroux i preti e qui
vediamo alcuni nomi in a nina che
significa mese patera prete via re andrà
marito clown a lenzuola ragona braccia
ai era cielo ma una pavone fortuna
forcone phuc una accendi d''olio
la cina antico strumento musicale oppure
metaforicamente uomo alto e stupido
cantun a camino cucina fuco delle api
oppure carbone dei cereali qui vedremo
alcuni esempi di nomi terminanti in a al
nominativo singolare primo esempio arter
che domina tu ma io adesso arriva il
mese di maggio o mina e il soggetto
quindi abbiamo la desinenza in a al
secolo esatto patera all e tesa marchi
emo ho confessato al prete tutti i miei
peccati to patera a chi al prete
complemento di termine quindi caso
dativo to matera ma o it on me non andrà
mo vado in campagna con mio marito
letteralmente sarebbe con il marito mio
non andrà e caso accusativo spediamo la
desinenza dell''accusa tivo perché in
acquisitiva perché è retta da me dalla
proposizione me quindi m nand ramo è un
complimento di compagnia con mio marito
isee sacca la cina
se come un calacione il calascione era
un antico strumento musicale alto e
sgraziato quindi per metà fra si intende
un uomo alto e stupido a buffon io fra
cona
mi fa male il braccio o fra cona è il
soggetto che compie l''azione del dovere
quindi abbiamo la desinenza in tailleur
nota avra cognato najera alzo le braccia
al cielo
qui vediamo come possiamo notare dalle
l''articolo determinativo tacche è neutro
che franconia è diventato di genere
neutro al plurale
oplà una enea pezzo meno il lenzuolo e
rattoppato oplà una è il soggetto quindi
abbiamo la desinenza a spa stesa ipla
oni
oppure possiamo dire tabla unia quindi a
due generi
innanzitutto diciamo che spazzi 6 brown
e significa si sono strappate le
lenzuola
quindi le lenzuola si può tradurre i
clown oppure tabla una un po come in
italiano che abbiamo due plurali i
lenzuoli le lenzuola
quindi questi nomi fra cona e oplà una
corrispondono ai nomi sovrabbondanti
italiani che hanno due plurali 1 per il
maschile è uno per il femminile e poi il
femminile corrisponderebbe in sostanza
al genere neutro come per esempio i muri
le mura', FALSE),
(5, 'GuHQfb3lJs4', 'Il Nome: Sostantivi Maschili in -i', 'nomi', 'Morfologia Nominale', '09:39', 696, 'Analisi sistematica dei sostantivi maschili uscenti in vocale -i. Vengono esaminate le desinenze dei casi, il comportamento del plurale e le eccezioni lessicali riscontrabili nelle parlate locali.', '«Mia megali charà» — Una grande gioia ripaga le fatiche della terra.', 'allora adesso analizziamo i nomi
maschili terminanti in i come possiamo
vedere dallo schema sono solo a rossi
doni cioè con l''accento sulla penultima
sillaba
analizziamo quindi il nome furnari al
nominativo singolare o fornari il
fornaio al plurale i furnari i fornai al
genitivo e da divo to furnari del
fornaio o sforna fornaro dei fornai
oppure al fornaio ai fornai accostati va
plurale casa del complemento oggetto
fornari tus fornaro il fornaio i fornai
i nomi maschili in sono pochi sono in
genere nomi di origine straniera e sono
solamente rossi doni
abbiamo caffè canape per esempio vediamo
che le residenze sono molto semplici
fine se prodotte con la è accentrata
vediamo quali sono i nomi più comuni
terminanti in o in mulinari mugnaio
barbieri barbiere scarpari calzolaio in
genere tutti i nomi indiganti un
mestiere anno la terminazione in scenari
gennaio nucleari febbraio aprili aprile
e quindi altri nomi di mesi ingenerano
la terminazione in poi abbiamo jury
padre massari assai bastasi ragazzaccia
di spada come nomi in abbiamo caffè
caffè che al plurale diventa nero da
caffè al canape divano vediamo questi
esempi o caio barbieri sicura islam o
nino quercia il miglior barbiere a
sternatia era nino quercia o barbieri e
il soggetto quindi a desinenza in una
vita pigra tuo molinari devi lasciare la
crusca al mugnaio a chi al mugnaio a
complemento di termine con sedativo
quindi desinenza sini plurimo me perni
il pozzo mio padre mi porta in campagna
suri è soggetta quindi caso narrativo i
futuri su nasar masi di a tuo padre che
ti faccia sposare giuri e complemento di
termine di aki a tuo padre
quindi jury è il caso dativo eni e snam
bastasi sei un ragazzaccio un mascalzone
vastasi erano i facchini questo termine
deriva dalla parola va storia significa
portare quindi i se non basta sia
comunque un significato dispregiativo
sei un ragazzaccio di strada un
mascalzone eccetera
iena ripiena fermi che ogni genera
questo è un proverbio
significa gennaio che nasce porta neve e
acqua
gli e nari e il nome di mese quindi la
terminazione sini del soggetto di non
accade tini mera oppure dio café ata
significa bevo un caffè al giorno oppure
due caffè quindi caffè al plurale ma
capita anche se per caserta si intendono
anche i residui del caffè
allora adesso prendiamo in esame i nomi
femminili in a
come possiamo vedere dallo schema
abbiamo nomi pro paro sironi cioè con
l''accento sulla terzultima a rossi toni
con l''accento sulla penultima eos titoli
con l''accento sull''ultima sillaba e
prendiamo in esame il termine fornita
che significa gallina allora la gallina
nominativo singolare giorni da le
galline giorni te poi al genitivo dativo
della gallina chi fornita delle galline
tos fornito all''accusa tivo abbiamo la
gallina di neuer nita le galline tesor
nyt e qui vediamo alcuni nomi femminili
in idrho da che significa sudore fornita
gallina talas a mare all''ipo una volpe
acli sia chiesa cardia cuore alleata
mucca
gioia in eca donna oppure moglie che ad
hera ragazza figlia coco vascia civetta
netta notte ratina pecora ora paese su
cea fico matria matrigna
adesso alcuni esempi di nomi femminili
in hasson di zotti nigro tattoo fronti
li asciuga il sudore della fronte di
nido da complemento oggetto caso
accusativo giorni dedicheremmo e cannon
play off
le mie galline non fanno più uova
letteralmente le galline mia giorni te e
soggetto quindi è nominativo plurale
tornerò tista l''ass
l''acqua del mare del mare complemento di
specificazione vediamo tease thalassa a
la desinenza del genitivo singolare ma o
cena crisi a un abuso lutri a vado in
chiesa per ascoltare messa cena crisi a
e il caso accusativo in questo caso
retto dalla preposizione sin e sarebbe
un complemento di moto a luogo lutri ha
invece è un caso acquisitivo perché
complemento oggetto cinismo cruz di
cardia lei mi ha rubato il cuore di
cardia complemento oggetto a caso
accusativo
provare a mezzo finale a da un g
la mucca la mucca complemento oggetto a
la desinenza dell''accusa diva del
complemento oggetto è mia ma li cara o
una grande gioia
mia cara e caso accusativo singolare', FALSE),
(6, 'yUnPN_rN2aE', 'Il Nome: Sostantivi Femminili in -a e in -i', 'nomi', 'Morfologia Nominale', '13:32', 1080, 'Rassegna dei sostantivi femminili con desinenza in -a e in -i. Spiegazione dello spostamento dell''accento tonico tra singolare e plurale e dei sostantivi a doppio significato.', '«I gineka echi poddhì logikò» — La saggezza della donna governa la casa e la corte.', 'allora adesso passiamo ad analizzare i
nomi femminili con desinenza in dallo
schema che qui vediamo possiamo renderci
conto come i nomi femminili in possono
essere prova rossi doni cioè con
l''accento sulla terzultima sillaba pa
rossi doni con l''accento sulla penultima
e rossi doni con l''accento sull''ultima
sillaba per quanto riguarda il primo
esempio abbiamo il nome fornita alcuna
se l''accento cade sulla penultima
sillaba lettera
senonchè pò cade sulla l''ultima sillaba
per quanto riguarda la declinazione
vediamo che le desinenze sono le
seguenti al nominativo singolare a al
nominativo plurale e per quanto riguarda
il genitivo dativo abbiamo singolare la
desinenza al plurale la desinenza o
mentre per l''accusativo al singolare al
plurale e ecco qui alcuni nomi femminili
in idrho da sudore fornita gallina talas
mare alcuna volte a crisi a chiesa
cardia cuore alleata mucca cara gioia
linea donna o moglie che a tera ragazza
o figlia cook mascia civetta nitta notte
radina pecora corà paese su cea fico
matria matrigna
ed ecco qui di seguito alcuni esempi di
nomi femminili in a
assen di zotti nigro tattoo fronti li
asciuga il sudore della fronte giorni
dedicheremo e canon cleo haga your needs
and soggetto è nominativo plurale
tornerò tista l''ass
l''acqua del mare del mare complemento di
specificazione caso il genitivo a come
residenza finale paos in harley sia una
corsa lutri a vado in chiesa per
ascoltare messa cena crisi a crisi a e
accusativo record alla preposizione sin
è un complemento di moda a loro in
accuso loubry a che cosa lucri a
complemento oggetto quindi va
dell''accusa livo cini mo blitz di cardia
lei e ha rubato il cuore di cardia è il
complemento oggetto ci accorgiamo che è
un caso così arrivò anche dall''articolo
team che è stato roncade in fiera
abbiamo messo il segno della venuta
francamente che la posto con ar mezzo
finale a da un g la mucca che cosa la
mucca complemento oggetto è mia ma li
cara o una grande gioia
che cosa una grande gioia
quindi come ci possiamo accorgere dall
articolo indeterminativo ed alla
terminazione di cara è un accusativo la
desinenza dell''accusa vivo qui vediamo
nomi femminili con desinenza al
nominativo singolare fini sono
pro parassita mi con accento sulla terz
ultima a rossi nomi con accento sulla
penultima aussiebum i con l''accento
sull''ultima sillaba le desinenze sono i
per il nominativo singolare e il plurale
è vivo ed attivo singolare i grigioni
vive da divo plurale o per la cosa viva
singolare chi per l''acqua saliva plurale
e e qui sono riportati alcuni nomi chini
vediamoli insieme
cannoni canapa agati amore cari grazie
favore da pronunciare aspirato ciò fa li
testa stati cenere detti giovedì a nemi
arco vaglio treaty buco con i voce grido
si anima di vita grandi mora giulia c
domenica atleti sorella
ap la corte cortile razaqi venerdì
quindi seguito alcuni esempi di frasi
con nomi femminili in i lucani mia cari
mi fai un favore che cosa mia cari
accusativo singolare buffoni e ciò fa lì
i cefali e il soggetto quindi caso
nominativo mi fa male la testa metiss
tattica nome tilli sia con la cenere
facciamo il bucato
etica post street e sottile ripe in
questo caso è soggetto da è e del
nominativo plurale ci sono tanti buchi
nel muro ma cameron e con e in questo
caso e complemento oggetto mi ha fatto
gridi sarebbe letteralmente mi ha
sgridato fauna briko tesa 3 fermo vado a
trovare le mie sorelle letteralmente le
sorelle
mi sa che cosa le sorelle quindi
accusativo è il caso del l''accusativo
plurale ma li parasse chi venerdì santo
i vesta di strambino e nero dini la
veste di mia nuora e rossa di scrum bimu
di chi li mia nuora quindi caso il
genitivo singolare allora qui vediamo il
paradigma dei nomi neutri chi no
osserviamo subito che ci sono nomi con
l''accento sulla terzultima sulla
penultima e sull''ultima sillaba dattilo
e significa di tossico significa fico e
anche uovo adesso osserviamo le
desinenze e notiamo subito che per il
singolare nativo genitivo dativo e
accusativo le desinenze sono uguali al
maschile così pure per il genio ed
arrivo plurale cambiano invece per il
nominativo plurale e l''accusa livo
plurale allora proviamo adesso a
declinare il nome dattilo il dito
allora o dattilo
il dito ad attila le dita to dattilo del
dito o al dito tosta e lo alle dita
delle dita toh dattilo il dito ad attila
le dita attenzione per l''accusativo
singolare a non pronunciare la parola
dattilo con la di raddoppiata
quindi pronunceremo dattilo e non
dattilo
questo perché l''articolo neutro non alla
n
quindi non cade non c''è il trattamento
della n e quindi non viene provocato il
raddoppiamento della consonante iniziale
della parola che segue in questo caso
dattilo quindi la pronuncia corretta
solo dattilo
ed ecco alcuni nomi neutri
conterminazione i no al nominativo
singolare quindi abbiamo dattilo ito
godano ginocchio sidero ferro al plurale
significa gli attrezzi cesaro corno
provato pecora nilo nel fico fico bruco
roba bene materiale al plurale significa
i vestiti tarocca significa i vestiti
silo legno kg al plurale abbiamo anche
da chi li le labbra 0 al plurale pateri
la mia di dura nero si dice anche nereo
al plurale tamer i significa parte ea ho
riso riso nel senso di ridere ago nuovo
nero acqua toccano il bene tocca co
il male ed ecco alcuni esempi
mou con un''età ago tana mi fanno male le
ginocchia ippolito godano i perni i
dolori delle ginocchia sono forti
toscolano e genitivo plurale no se
desidera capresi raccoglie gli attrezzi
perché piove desidera neuro plurale c zo
metà sica a caso cannizzo tagliamo i
fighi sul canniccio da sica che cosa
componendo getto a cosa viva plurale
fine oria città kg sordina come sono
belle quelle tue labbra rosse mogam e la
camorra possa iaia mi ha fatto fare
tante risate
ieri a risate laccato nero per la parte
di sotto
il sito nereo da quella parte vede che
ci sono le due terminazioni nero e nereo
top urru corto ago il tuorlo dell''uovo
di che cosa
nell''uovo complemento di specificazione
caso il celivo abu e valet arouca c
nuccia ha indossato e robe nuove enea
tecu di e nei chirurgo e poveretto non
ha averi sarebbe non a roma roba nel
senso di ricchezze averi quindi il
doppio significato di ruco come averi e
come vestiti', FALSE),
(7, 'lFkRMXvJMzA', 'Il Nome: Sostantivi Neutri e Sovrabbondanti', 'nomi', 'Morfologia Nominale', '11:38', 1027, 'Trattazione del genere neutro (terminazioni in -o e in -i con plurale in -a), preziosa reliquia ereditata dal greco antico assente nell''italiano, e dei nomi sovrabbondanti con doppio plurale.', '«O lio ''en echi fòo» — Il poco cibo non teme i ladri (la frugalità porta serenità).', 'no mi neutri in allora vediamo dallo
schema che ci sono nomi a rossi toni
cioè cosa cento sulla penultima come a
nichi che significa unghia e nomi rossi
doni con l''accento sull''ultima sillaba
come atti che significa orecchio diamo
uno sguardo alle desinenze allora
abbiamo i per il negativo singolare io
ce ne diventa tivo singolare accusativo
singolare al plurale invece andiamo via
io e io allora proviamo a declinare il
nome a chi e significa orecchio allora o
ati l''orecchio tratti ha le orecchie tu
addio dell''orecchio all''orecchio tosatti
o delle orecchie alle orecchie poi
accusativo singolare o ati accusativo
allora le età addio quindi l''orecchio le
orecchie e teniamo presente che addita
davanti a una vocale si può anche posso
fare
allora abbiamo amici unghia anche lì e
al plurale fa ampia linea ala di olio al
honi che al plurale fa alogna aia
cazzari pesce asteri stella ahmadi
occhio arni agnello votare albero di
olivo atti orecchio e di ragazzo figlio
anche scanni sgabello corti cascina
cicli matassa luri cinghia liti cave
ceri c''ero allora qui vediamo degli
esempi di nomi neutri in vasi tanica
dipinge le unghie tanica complemento
oggetto vediamo che qui atti vità è
stato apostrofato perché è che la parola
che segue incomincia per votare amp iac
amena vigne bruciate è una località in
agro di sternatia tosta fili to ampelio
l''uva della vigna qui vediamo due parole
neutre tutte e due
fini sta fili e anche lì lo stati lì è
nominativo singolare e tu ampelio e
genitivo singolare nella pigna tal madia
turazza rio
anche qui la madia gli occhi del pesce
la madia e nominativo plurale tu faccia
rio genitivo singolare del nome affari
e qui azzena nati non sente da un
orecchio nati e un accusativo singolare
eretto dalla deposizione a e vale tria
porti a portà riuso furno ha messo le
fascine di albero di olivo nel forno
qui abbiamo anche due parole neutre in i
forti e codari quindi crea porti a e
accusativo plurale ammesso che cosa 3
fascina o da rio e jane divo singolare
di albero di olivo cretina sfizi dolori
bisogna stringere la cinghia soluri e
l''accusativo neutro anas o la tra ceri a
pisa crisi ha acceso tutti i ceri della
chiesa aceri a che cosa tutti i ceri
accusativo neutro plurale ed eccoci
arrivati alla fine di questa nostra
lunga carrellata sul nome e quindi in
questa diapositiva analizziamo i nomi
neutri in a
vediamo che ci sono nomi con l''accento
sulla terzultima prova rossi vani e nomi
con accento sulla penultima a rossi
tommy haas 3 ma significa lampo insomma
significa corpo
diamo uno sguardo alle desinenze per il
nominativo singolare a per il nominativo
plurale ah ah ah tu per il genitivo e da
divo singolare ato per il genitivo e
dativo plurale a per l''accusa divo
singolare ada
per l''accusa divo plurale
proviamo quindi a declinare aspre ma il
lampo allora to us trema il lampo a
stremata i lampi vedere che al plurale
si sposta l''accento sulla a stremata poi
al gengiva ed arrivo singolare tua
stremato
anche qui si spostano al 100 possa ha
stremato cieli di venderli o plurale per
l''accusativo abbiamo astro e ma oppure
tas ferma posto vado da la strenua da
per l''accusa di won euro plurale ed ecco
alcuni nomi astrim lampo gramma lettera
soma corpo derma del jèma sangue roma
per sé ma lucia gala latte
no ma 9 crea carne al plurale da creata
significa anche le parti del corpo o la
carnagione in genere ed ecco qui degli
esempi di nomi neutri e na na su dall
ass 3 ma che dica da un fulmine
letteralmente sarebbe che ti dia un
fulmine ma grazie dio gramma ta mi ha
scritto due lettere vedete il singolare
gramma il plurale gramma ta e keenan
dermaku fede cassi ma ha una pelle che
sembra io progetti c''è dubbi e iema si è
ferito
egli è uscito sangue
da merito somato le parti del corpo
navi di sé ma da non dire bugie basta a
crea da rovina ha la carnagione rosea
allora cari amici abbiamo finalmente
concluso questa lunga carrellata sul
nome nelle sue diverse forme nei suoi
tre generi maschile femminile e neutro e
le sue varie desinenze logicamente
qualcuno potrebbe obiettare ma come si
fa a memorizzare tutti questi schemi e
tutte queste regole
teniamo presente che una lingua si
impara come ho già avuto modo di
rilevare soprattutto con l''uso
certamente le regole grammaticali
aiutano ma teniamo presente che i nostri
genitori le regole le applicavano senza
alcun errore poiché apprendevano la
lingua sin dalla nascita fino a 50 60
anni fa
il clima si parlava in quasi tutte le
famiglie dei nostri paesi ed era
comunemente usato nei rapporti
interpersonali
comunque io avrei un suggerimento da
dare
anziché ricordare a memoria schemi e
regole
il che risulterebbe alquanto difficile e
improbabile è preferibile ricordare
alcuni pochi esempi e da essi ricavare
la regola così ad esempio osservando lo
schema del nome è sufficiente ricordare
un nome per ogni desinenza del maschile
femminile e neutro
ad esempio per il maschile possiamo
ricordare anche per la desinenza o
matera per la desinenza a scarpari per
la iii e cup e per la residenza e per il
femminile possiamo ricordare la parola
fornita giorni da ci fa capire che la
desinenza è in canna mi sini
e per il neutro dattilo a nichi l''unghia
aspem il lampo eccetera
naturalmente potremo anche scegliere
delle altre parole il problema nasce
quando le desinenze coincidono per
maschile femminile nel pro come può
succedere per esempio per la del
maschile la desinenza che è uguale alla
residenza o del neutro oppure al
maschile a che è uguale al femminile a
oppure al neutro in a e così pure per la
desinenza geniche comune sia per il
maschile sia per il femminile e sia per
il neutro a questo punto come fare
allora per capire il genere di un nome
bisogna affidarsi al vocabolario oppure
alla pratica quotidiana della lingua
questo è tutto
vi do appuntamento alla prossima lezione
ciao ciao', FALSE),
(8, 'EX3WDyF42R0', 'L''Aggettivo Qualificativo', 'aggettivi', 'Aggettivi', '32:14', 2463, 'Lezione monumentale di oltre mezz''ora che classifica gli aggettivi qualificativi in tre gruppi morfologici. Regole di concordanza di genere e numero ed esemplificazione su ricchi contesti della quotidianità.', '«I kalì melissa panta meli kàmni» — La buona ape fa sempre buon miele.', 'benvenuti a questa nuova lezione dove
tratteremo l''aggettivo qualificativo
l''aggettivo segue il nome nel genere e
nel numero quindi anche in griko può
essere maschile femminile o neutro dando
uno sguardo alla schermata che vi
propongo possiamo notare subito che
sostanzialmente ci sono quattro gruppi
di aggettivi al primo gruppo
appartengono aggettivi che hanno la
desinenza al nominativo singolare i no
per il maschile in italy femminile e in
o per il neutro come per esempio
l''aggettivo aspro che significa bianco
che fa aspro aspri aspro quindi aspro
bianco aspri bianca aspro bianco
riferirò al nome euro
poi al secondo gruppo abbiamo aggettivi
da cui desinenza e o per il maschile a
per il femminile over il neutro come
paleo paleo che significa vecchio e fa
paleo vale a paleo quindi vecchio
vecchia vecchio riferito a 9 euro al
terzo gruppo abbiamo aggettivi la guida
esigenza e sini per il maschile ea per
il femminile
i per il neutro come ad esempio l''ici
significa dolce bici giudice a glee c
poi c''è una cro gruppo di singoli
aggettivi che potremmo chiamare
irregolari come per esempio o di e
significa molto
e fa o di o di polizia al maschile sia
femminile e sia al neo pro malo che
significa grande che fa male male male
però anche un''altra forma né accanto a
malo mali ma lo abbiamo anche ne ha per
il maschile ma lì per il femminile ne ha
per il neoton un altro aggettivo che ha
una coniugazione a sé e assegnatari che
significa bugiardo che fa a sematary a
sé matara azema taro per il neutro
cominciamo allora ad analizzare gli
aggettivi appartenenti al primo gruppo
come possiamo vedere dallo schema gli
aggettivi del primo gruppo possono avere
delle residenze rispettivamente in o per
il maschile sini per il femminile è in o
per il neutro
vediamo alcuni aggettivi arciero vuoto
aspro bianco asilo alto
quali sono le desinenze allora abbiamo
residenza del nominativo singolare i no
per il maschile e il femminile e in o
per il neutro al plurale abbiamo i per
il maschile e per il femminile ea per il
neutro
andiamo al caso il genitivo d''arrivo che
è il complemento di specificazione di
termine lo ricordo abbiamo per il
maschile e femminile e per il neutro al
plurale abbiamo o maschile femminile n
euro andiamo al caso accusativo che è il
caso del complemento oggetto abbiamo o
per il maschile e femminile o per il
neutro al plurale per il maschile e
femminile a neutro
vediamo adesso alcuni esempi
prendiamo in esame alcuni nomi maschili
femminili e neutri e quindi vediamo che
gli aggettivi si accordano in genere e
numero col nome a cui si riferiscono
allora vediamo il primo esempio ottico
aspro quindi dico è un nome maschile
come possiamo vedere anche dell''articolo
o aspro e la desinenza del maschile
singolare
eccola al plurale itc aspri la desinenza
del maschile plurale
vediamo un nome femminile e gambara
arcieri la stanza la camera vuota
allora gambara e il nome femminile
arcieri e la desinenza del femminile
singolare questa al plurale i cabaret
arciere le camere vuote da è è la
desinenza del femminile plurale
vediamo adesso nome neutro tappeti asilo
e di e un 9 neutro come possiamo vedere
anche dall''articolo ton che lo precede
asilo e la desinenza del neutro
singolare eccola tappe di aa sila
i ragazzi al ti alzi la quindi è il
neutro plurale andiamo al complemento di
specificazione termine caso il genitivo
d''arrivo tu ti aspro quindi dico è
sempre un nome maschile significa del
muro bianco complemento di
specificazione oppure anche al muro
bianco
e la desinenza e la u del maschile
singolare al plurale tossico aspro
quindi aspro e la desinenza del genitivo
maschile plurale kiss cam bara arcieri
della camera vuota
occorre alla camera vuota la i e la
desinenza del generico da divo singolare
toscan baro arciero delle camere vuote
lo è il genitivo da divo del femminile
plurale
tu che ti alzi lu del ragazzo alto o al
ragazzo alto e il genitivo singolare
maschile sospetti o asilo dei ragazzi
alti il genitivo da divo plurale di un
nome neutro
eccolo qua andiamo al componente oggetto
caso accusativo totti co aspro allora il
muro bianco
vedete che l''articolo è eto''o c''è un
apostrofo col dire che è caduta una n
quindi la parola che segue si pronuncia
con l''ati raddoppia da totti co aspro
quindi la o e la desinenza dell''accusa
tivo maschile singolare giusti aspro
l''accusativo plurale come possiamo
osservare anche dall articolo
tus di gambara arcieri la camera vuota
la i e la desinenza dell''accusa tivo
singolare e scambiare carcere è questa
dell''accusa vivo plurale femminile dove
ti alzi lo quindi nome neuro asilo e la
desinenza dell''accusa livo neutro
singolare tappeti arazzi la il neutro
plurale passiamo adesso a gli aggettivi
del secondo gruppo allora osserviamo lo
schema e vediamo che le desinenze degli
aggettivi del secondo gruppo sono i no
per il maschile in a per il femminile e
hino per il neutro
ci sono alcuni esempi di aggettivi cin
urge nuovo pacchetto grosso valeo
vecchio ed esigenze sono le seguenti o a
o x maschile ordinativo maschile chi è
ea per il nominativo femminile 15 liu jo
chirurgici norcia ccc murge synergy per
ragioni di vada livorno o maschile a
femminile o neutro o maschile femminile
è neuro plurale per l''accusativo sono o
per il maschile a per il femminile o per
il neutro al plurale e e da vediamo
alcuni esempi o argalìo cin urge argalìo
nome maschile infatti c''è anche
l''articolo
siamo cin urge si accorda con il nome
maschile quindi la o della residenza del
maschile singolare al plurale fi arga li
cin urge chirurgi e la desinenza del
maschile plurale un nome femminile e gli
nega nega ma crea la donna grossa da
della desinenza del nominativo femminile
singolare e linee che bach e cioè in
questo caso è invece significa le donne
grossa al plurale la è è la desinenza
del nominativo femminile plurale tratti
paleo il letto vecchio crati è un nome
neuron paleo no della desinenza del
neutro nominativo neutro singolare da
grazia palea eletti vecchi la di male a
sé il nominativo neutro l''orale passiamo
al genitivo da divo tuarga liu paleo del
telaio vecchio o al telaio vecchio la u
e la desinenza del genitivo da divo
maschile singolare tos argalìo paleo dei
telai vecchi o ai telai vecchi no è la
desinenza del genitivo maschile plurale
la tis linee
ma che ha della donna grossa o alla
donna grossa macchia e il caso genitivo
da divo femminile singolare tosti né co
packer delle donne grosse al plurale
abbiamo no del genitivo d''arrivo plurale
che questa to crativo paleo del letto
vecchio la ue e la desinenza del
genitivo neutro singolare e questa tosca
theo paleo dei letti vecchi paleo sempre
o e la desinenza del genitivo dativo
neutro plurale che questo vediamo
l''accusativo accusativo quando fa da
complemento oggetto ricordo quindi donna
argalìo paleo il telaio vecchio lo è
questa dell''accusa divo maschile
singolare tus argalìo paleo how e questa
l''accusa tivo plurale del maschile king
in è capace a la donna grossa vediamo la
dell''accusa tivo femminile singolare e
questa tesi di nega pa che le donne
grosse la è dell''accusa tivo femminile
plurale
adesso al neutro o tratti quale o neutro
accusativo neopro singolare
ecco la track racchia talea eletti
vecchi la di pale a e l''accusativo neuro
plurale ed eccoci arrivati agli
aggettivi del terzo gruppo
osserviamo la tabella e vediamo che le
desinenze degli aggettivi appartenenti
al terzo gruppo sono in per il maschile
ea per il femminile è in per il neutro
abbiamo degli esempi di aggettivi blici
che significa dolce steri duro vari
pesante le desinenze sono per il
nominativo e per il maschile ea per il
femminile e per il muro al plurale e ea
per il caso genitivo da divo e ea
interior maschile femminile neutro
singolare io io io x maschile femminile
neopro blur al e all''accusa tivo e è a
sé e sé e ha quindi se dobbiamo
declinare luigi diremo l''ici liceo glee
cgc lì c''è vice a e così via
vediamo alcuni esempi sacco vari sacco e
un nome maschile vari e la desinenza del
maschile singolare al plurale sacchi
vari
allora abbiamo anche qui la desinenza
del nominativo plurale maschile torta
licea torta è il nome femminile glitch
ea e la desinenza del femminile
singolare torte bleach femminile plurale
cocca lo steri testa dura steri laidi
isterie e la desinenza del neutro
singolare coccola stereo crea e la
terminazione del neutro plurale
da notare come leggiamo nella nota che
gli aggettivi appartenenti a questa
classe orc e alle desinenze sini e ai
possono avere anche quella del secondo
gruppo però con desinenza in sé o ea e
ho quindi oltre che steri stere asteri
possiamo anche dire stereo stereo stereo
e così al plurale resterei stere stereo
e così via
perciò possiamo avere il liceo licei al
liceo stereo stere a stereo
l''areo l''area vario ma creo ma crea ma
crea quindi glitch e ora abbiamo detto
significa dolce stereo duro
l''areo pesante ma creo lungo adesso
vediamo alcuni altri aggettivi che hanno
una declinazione particolare e delle
desinenze particolari abbiamo
l''aggettivo
sematary bugiardo che a queste desinenze
in per il maschile in a per il femminile
e in o per il neutro
quindi sarebbe assegnatari azema tara al
sema taro allora singolare quindi
bugiardo bugiardo bugiardo al plurale a
sematary al sema dare a se ma darà
quindi poggiardo bugiarde bugiardi per
il nostro
vediamo comunque alcuni esempi o altre
po a sematary l''uomo bugiardo anche col
maschile a sematary e la desinenza del
maschile singolare i propri sematary
plurale maschile sematary e questa
desinenza dai del maschile plurale e gli
nega a se ma darà la donna bugiarda
quindi gli nega e femminile va e la
desinenza del femminile singolare che
questa chi nega a se ma tare femminile
plurale toppe di azema taro il ragazzo
bugiardo e di come sappiamo è neutro no
è la desinenza del neutro singolare da
reti a a sé ma darà quindi neuro plurale
ma è questa allora altri aggettivi che
hanno una declinazione particolare sono
i diminutivi degli aggettivi vediamo che
hanno la desinenza in
per il maschile e da per il femminile u
d per il neutro
prendiamo come esempio l''aggettivo
attenuti che è diminutivo di povero
quindi poveretto fa al nominativo a te
cudi non ne arrivò singolare maschile
fatte chieda femminile a te cudi neutro
al nominativo plurale a te cudi per il
maschile a te chiede per il femminile
plurale a the ku di avere il neuro
plurale
vediamo adesso alcuni esempi
allora o andremo a te cudi anche è un
nome maschile a te cudi e la desinenza
del maschile singolare al plurale ian
propri attributi quindi maschile plurale
nominativo gli nega atti che dà la donna
poveretta a te qaeda e la desinenza del
femminile singolare gli nega a te chiede
le donne ove rette e ed il la desinenza
del nominativo femminile plurale toppe
di obbedire un nome neutro top e thq di
il ragazzo poveretto udi e la desinenza
del neutro singolare caso nominativo
tappeti a a te cumbia i ragazzi
poveretti quindi neutro plurale
nominativo passiamo al caso il genitivo
e da divo to antropo hq di
dell''uomo poveretto oppure all''uomo
poveretto a tra curdi e la desinenza del
maschile singolare vd al plurale degli
uomini poveretti oppure agli uomini
poveretti attendo la desinenza
dell''incentivo d''arrivo plurale maschile
tease di nega a te chieda della donna
poveretta quindi femminile singolare
caso genitivo d''arrivo toh skineco
attecchendo delle donne proverete o alle
donne poverette ed ho la desinenza del
bisogno di coda tivo plurale tube thq di
neuro singolare hq di josp ed io a te
buio neutro plurale passiamo al caso
accusativo donna altre porte a cui
l''uomo poveretto good to saint robot a
the good gli uomini
poveretti caso accusativo plurale voodoo
team di nega parte che dà la donna
poveretta accusativo femminile singolare
test di nega a te chiede accusativo
femminile plurale toppe di attenuti
l''accusativo neutro singolare da pedia a
tavullia
accusativo neutro plurale allora un
altro aggettivo che ha una declinazione
particolare è l''aggettivo podi e
significa molto a chi come desinenza sia
al maschile sia femminile e sia al
neutro
vediamo un po alcuni esempi indosso e
chi o di bombi co qua dentro c''è molto
rumore molto frastuono bombi co fa da
soggetto in questo caso e podi
accordandosi con il nome a cui si
riferisce con il nome che accompagna a
come desinenza lai del nominativo
maschile singolare bombi co e un nome
maschile che altezza o the road e ho
piantato molti melograni od europee
complemento oggetto quindi abbiamo la e
del l''accusativo femminile plurale o
molinari moritz o di allegri
anche qui allegri fa da complemento
oggetto o di si accorda con il nome che
accompagna e quindi o di e la desinenza
del complemento oggetto accusativo
neutro singolare o da asta chai pesano
adraino molte spighe sono cadute dal
carro allora a stage è un nome neuro
plurale o da si accorda con asta cia
quindi è la del nominativo
neutro plurale perché vada sta già fa da
soggetto o di arcola dei molti alberi
questo caso abbiamo il genitivo da divo
plurale di un nome maschile quindi
abbiamo o di lauti pò zucche incentivo
d''arrivo plurale maschile
allora qui abbiamo un altro aggettivo
malo che significa grande che ha una
coniugazione particolare le desinenze di
ma lo sono o per il maschile e femminile
o per il neutro
però abbiamo anche me sa che fa mea per
il maschile ma lì per femminile linea
per il neutro come possiamo vedere anche
qui nel prospetto delle desinenze
vediamo alcuni esempi
nun andrè con malo un uomo grande però
si vuol dire anche non altre come a al
plurale dio
i propri mali due uomini grandi in
questo caso non possiamo usare
l''aggettivo one a mali è la residenza
del nominativo maschile plurale minghi
nega ma lì una donna grande mali e
femminile singolare che questa
l''esigenza mali dio linee che ma le due
donne grandi e il nominativo plurale
quindi abbiamo
ma le nappe di malo edn euro ma lo la
desinenza del neuro singolare però
possiamo anche dire nappe di né a dio
che dia ma l''ha anche in questo caso non
possiamo usare ne ha ma ma la ma
l''animale e la desinenza del nominativo
neutro plurale
allora questo è tutto quello che
dovevamo dire per l''aggettivo vi saluto
e vi do appuntamento alla prossima
lezione
ciao ciao', FALSE),
(9, 'eXAcJxO-beQ', 'I Gradi dell''Aggettivo: Comparativo e Superlativo', 'aggettivi', 'Aggettivi', '17:07', 1588, 'Formazione del comparativo di maggioranza, minoranza e uguaglianza (uso di ''plon'' e ''ata''), unitamente ai meccanismi perifrastici e morfologici per formare il superlativo assoluto e relativo.', '«Plon kalò ''n ena poddhì para ''na lio» — Meglio avere abbondanza che soffrire la penuria.', 'cari amici benvenuti a questa nuova
lezione nella quale analizzeremo i gradi
dell''aggettivo qualificativo come
sappiamo dalla grammatica italiana i
gradi dell''aggettivo sono tre positivo
che grado normale cioè con esso si vuole
esprimere una qualità attribuito al nome
senza fare alcun confronto grado
comparativo con cui si confrontano e si
paragonano due qualità
il grado superlativo con cui si esprime
una qualità al massimo grado
bene ora in questa diapositiva
cominceremo ad analizzare il comparativo
come già detto comparare significa
confrontare paragonare tra loro due
qualità riferite a persone animali o
cose
si presuppone quindi che ci siano due
termini di confronto che vengono
chiamati primo e secondo termine di
paragone primo e secondo termine di
paragone
ad esempio se dico mario è più alto di
giorgio si stanno mettendo in confronto
cioè si stanno paragonando mario e
giorgio mario è il primo termine di
paragone giorgio il secondo termine di
paragone bene adesso osservando lo
schema sinottico della diapositiva
vediamo che il grado comparativo si
distingue in comparativo di maggioranza
comparativo di minoranza e di
uguaglianza
vediamo un po come sono espressi in
griko allora per quanto riguarda il
comparativo di maggioranza noi troviamo
nel primo termine la verve york l''on
mentre nel secondo termine di paragone
possiamo provare una delle seguenti
preposizioni tiri a sé ata però
solamente davanti a nomi neutri e prono
minelli e ca facciamo qualche esempio
ma io ti rimena 6 migliore di me il tier
i in questo caso è stato tradotto la
preposizione di isee clonati lo sa se
meno sei più alto di me tappe di a mou
in e la noria ata di gas
ecco qua vediamo che il secondo termine
di paragone è introdotto da ata perché
perché di cassa è un pronome neutro
plurale i miei figli sono più belli dei
tuoi quindi anche in italiano poi è un
pronome possessivo
allora adesso vediamo il comprensivo di
minoranza con prativa di minoranza
introdotto nel primo termine di paragone
daclon al io nel secondo termine di
paragone le stesse preposizioni però
occorre dire che questa forma e poco usa
da infatti anziché dire ivo ime clonali
russia tiri sena che significa io sono
meno ricco di te si preferisce
trasformare la frase è dire tu sei più
ricco di me quindi ripeto ancora questa
forma e poco usata poi passiamo al
comparativo di uguaglianza nel
comparativo di uguaglianza troviamo
posso al primo termine di paragone possa
al secondo termina esempio i se posso
asilo possono isef essa sei tanto alto
quanto sei sesso quindi posso possono
questa n è una n
fonica in quanto la parola che segue
incomincia aver vocale isee si può
arrendere ancora il comparativo di
uguaglianza con i to nel primo termine e
qundo più articolo nel secondo termine
esempio isee itu assimo un dotto debito
sei così brutto come il debito però si
può mettere nel primo termine di
paragone etoo e dire isee massimo un
debito così pure in italiano si può
mettere il così sei brutto come il
debito
un''altra forma di compra tivo di
uguaglianza è la seguente il primo
termine di paragone nessuna preposizione
nel secondo termine di menegon e la
preposizione sun che corrisponde all
italiano come allora i cat eramo e
negligé a san meli mia figlia è dolce
come il miele
naturalmente davanti a me li non si
mette l''articolo non si dice felice a
san tomè di ma licea same lì come se in
italiano dicessimo mia figlia è dolce
come miele sun medi e adesso diamo uno
sguardo al grado superlativo che si
distingue in super nativo relativo è
superlativo assoluto come si forma il
superlativo relativo esso si forma
premettendo l''articolo al comparativo di
maggioranza
un esempio otto ore guarda la rota e ne
ho pro nazi lo attico ra salvatore
guardava rosa è il più alto di ster
la dia che cosa abbiamo fatto abbiamo
preso il grado comparativo clonati lo
superlativo in quanto abbiamo premesso
l''articolo o spieghiamo un attimo che
cosa significa superlativo relativo
superlativo indica che si esprime una
qualità al massimo grado però
relativamente a qualcos''altro
infatti se io dico salvatore guarda
guarda la rosa è il più alto di
sternatia e il piu alto però
relativamente agli abitanti di sternatia
passiamo alla superlativa solutorio
superlativo assoluto significa invece
che si esprime una qualità al massimo
grado senza però fare alcun confronto
la parola assoluto significa sciolto da
qualsiasi confronto
come quando andiamo dal confessore e ci
dà l''assoluzione che ci toglie da
qualsiasi peccato come si forma il
superlativo assoluto si forma
premettendo all''aggettivo di grado
positivo o di motore guardava roda e nel
po di asilo salvatore guarda la ruota è
molto alto in italiano possiamo dire
dire anche assai alto altissimo eccetera
si può formare il superlativo assoluto
anche non altro modo
in griko ripetendo due volte lo stesso
aggettivo motore guarda la ruota e ne
asilo asilo salvatore guarda la roba è
altissimo
molto alto sai alto eccetera
allora adesso qui vediamo alcuni esempi
relativi al grado comparativo e al grado
superlativo tocco finimmo e nei blog ma
i rito di dosso il mio paniere è più
pieno del
tuo vediamo che qui possiamo salire sia
nel secondo termine di paragone possiamo
usare sia diritto di costo la
preposizione viri oppure atto ad ogni
costo
questo perché di costo è un pronome
neutro preceduto dall articolo attore ci
si nega e ne bloccherà pv sena oppure a
cesena
quella donna è più piccola di te
possiamo usare sia iris e na sia a
cesena ucciso pdn planas iloca condò
siamo anche dire stop e di anziché cisap
e di quel ragazzo è più alto che basso
in questo caso come secondo termine nel
secondo termine di paragone
abbiamo provato la congiunzione ca o
iorgi e ne clonali 8 tiri con toni
questo è un esempio di comparativo di
minoranza abbiamo già detto e che si usa
poco dire così
e preferibile volgere la frase è
trasformare la frase è dire anzi che
dire
giorgio e meno povero di antonio è
preferibile dire antonio è più ricco di
giorgio andiamo ad un esempio di
comparativo di uguaglianza thyssen e i
tuoi a 11 thing hynek a chi è così bella
come quella donna
possiamo anche dire chi se ne oria senza
aiuto 11 tinghi nega come quando in
italiano diciamo chi è
nella come quella donna
ecco togliemmo riccò sacco li tengo la
bocca amara come il fiele come la bile
posso dire sacco lì oppure un dott
coli da notare che se uso sun non ci
metto l''articolo
mentre se uso qundo posso dire condotti
colitti el''articolo accusativo femminile
singolare isolo isee o professa ancora
tu sei il più stupido di sternatia è un
esempio di superlativo relativo social
hub a chi sale portò meno corto meno il
carro era assai carico in questo caso è
un superlativo assoluto ed è stato reso
rivedendo due volte
l''aggettivo forte meno allora adesso
daremo un rapido sguardo a due aggettivi
che hanno un comparativo è un
superlativo irregolare questi due
aggettivi sono caco cattivo e calò buono
vediamo come fanno al grado comparativo
superlativa relativo è superlativo
assoluto per quanto riguarda il
comparativo capo fa siro e significa
peggiore calo fa caio significa migliore
però vediamo che sia tiro sia caglio
possono avere davanti a sé l''avverbio
plon che significa più come se in
italiano dicessimo cosa che non si può
dire più peggiore o più migliore lo
diamo anche che la n diploma
davanti alla cd kiro si è leader che c''è
un troncamento e così pure davanti al k
di caio
passiamo al superlativo relativo vediamo
che davanti a pro tiro viene premesso
l''articolo
quindi il peggiore o blog tiro però è
come se in italiano dicessimo il più
peggiore cosa da non dire ed a non
scrivere mai ho bloccato il migliore per
quanto riguarda il superlativo assoluto
è molto semplice si forma premettendo
all''aggettivo di grado positivo capo e
calò l''avverbio o di molto quindi po di
caro molto cattivo assai cattivo
cattivissimo col piccolo molto buono
assai buona eccetera
vediamo adesso alcuni esempi ci sono
altre pene plot tiro i rimena quell''uomo
è peggiore di me pieri mena e il secondo
termine di paragone in questo caso è
prodotta da piri possiamo dire sia block
tiro sia siro è indifferente al
superlativo relativo invece vediamo un
po o blocca gli operati corà e ne ho
petit his mother era il migliore ragazzo
di sternatia e il figlio della madre ma
in questo caso essendo un superlativo
relativo mettiamo forzatamente
l''avverbio l''on
o caio altro esempio to sopra si è po di
calo
questo è un esempio di superlativo
assoluto quindi questo vino è molto
buono e buonissimo
no si è formato premettendo all attivo
di grado positivo calo
l''avverbio o di un avvertenza caio può
essere usato anche come avverbio e così
pure kiro soltanto che quando è avverbio
siro prende la forma siro facciamo un
esempio kajana casi non dattilo i riti
fiera
meglio perdere un dito che la mano
questo proverbio quindi caglio in questo
caso fa da avverbio quindi significa
meglio e non migliore altro esempio
siro via sena peggio per te tiro e
avverbio e che significa peggio appunto
e non peggiore bene con questo credo di
aver dato una panoramica completa sul
grado con pratico è superlativo dei vari
aggettivi per adesso vi saluto e vi do
appuntamento alla prossima versione
ciao a tutti', FALSE),
(10, '-cIgt2pDVKo', 'Aggettivi e Pronomi Possessivi', 'pronomi_numerali', 'Pronomi & Numerali', '22:35', 2127, 'Distinzione cardine tra forme toniche enfatiche (''diko-mu'') e particelle enclitiche atone posposte (''-mu, -su, -tu, -ma, -sa, -to''). Approfondimento sulle regole di raddoppiamento fonosintattico dell''enclisi.', '«O kàsso ena vlépi ta pedìa-tu orria» — Ciascun genitore vede i propri figli come i più belli del mondo.', 'cari amici ben trovati a questa nuova
lezione nella quale parleremo degli
aggettivi e pronomi possessivi i
possessivi hanno una forma tonica cioè
accentrata è una forma atona che non ha
un accento proprio ma si appoggia alla
parola che precede e perciò si chiama in
critica cominciamo con l''analizzare le
forme cliniche che vediamo rappresentate
in questa slide
diciamo innanzitutto che le forme in
critiche del possessivo si usano solo
come aggettivi proprio perché si
appoggiano alla prova che precede mentre
le forme toni che possono essere sia
aggettivi sia pronomi cioè possono
accompagnare un nome o sostituirlo
dunque osservando la tabella vediamo che
i possessivi atomi sono 1 su 2 e ti ma
sa ciò che corrispondono al gent ivo del
pronome personale a tono che studieremo
in un''altra lezione a parte e che
corrispondono alle particelle pro
nominali italiane mitici vi si quindi
osservando la tabella vediamo che ho la
prima persona singolare del possessivo
si traduce in italiano con mio mia miei
mia supporto tua puoi due duetti con suo
sua suoi sue ma con nostro nostra nostri
nostre sa con bosco vostra costi vostra
età con loro la prima cosa che balza
subito agli occhi è il fatto che mentre
italiano abbiamo una forma per il
maschile per una per il femminile una
vera il plurale
in griko invece abbiamo un''unica forma
quindi se noi italiano siamo ad esempio
il nome maschile diciamo mio padre in
griko lo traduciamo o jury mou mia madre
iman a mou i miei fratelli e atletismo e
mie sorelle e ad ritmo
lo stesso vale per la parcella suo
quindi tuo padre o jury su tua madre
umana su i tuoi fratelli di altre fisso
due sorelle di altre fesso per quanto
riguarda l''aggettivo possessivo di terza
persona dobbiamo notare questa
differenza che dentro in italiano noi
usiamo suo sua suoi sue e ci possiamo
riferire sia a 9 maschile sia al nome
femminile
ad esempio se io dico ho visto suo padre
non so se il padre di lui o il padre di
lei in griko invece si fa una
distinzione se mi riferisco al padre di
lui
dirò i da julie tu se invece mi
riferisco al padre di lei di rho i dato
jury ti ho visto suo padre cioè il padre
di lei
jury di poi vediamo che nostro nostra
nostri nostre quindi abbiamo detto viene
spesso della particella ma lo sfogo spa
vostri ghost sa loro dalla particella
top
adesso andiamo a fare degli esempi o
andrà muqer se si germania mio marito è
partito per la germania o andremo a noi
l''en critica o i patti mo a petain aned
e saroos crono ampi i miei nonni sono
morti
morirono quattro anni fa quattro anni
addietro i papi e plurale e deve sempre
fraticello jadine gas m chiarita perché
tua moglie non mi saluta gli nega nome
femminile su sempre la particella unica
particella con ha gradito per il
maschile femminile singolare e plurale o
petisso paesi scola tuo figlio va a
scuola e tn euro si dovrebbe dire top e
tissot però noi a sternatia spesso
diciamo o petisso vedete che qua e di è
una parola o si dona cioè con l''accento
sull''ultima sillaba in questo caso
quando la centro cade su l''ultima
sillaba si raddoppia la consonante
iniziale della forma a tana
quindi o petisso biscolla tua grotti e
ne sale nata la cravatta di suo marito e
ingiallita quindi quali anche qua
vediamo che andrò al centro sembravo
quindi la chiesi raddoppia
teniamo presente che in italiano diciamo
di suo marito dalla frase si capisce che
ci rivediamo a un nome femminile però
vedete che il griko fa distinzione tra
il tool healthy suo di lei possa
padre oberst o ma anche qui l''accento è
solo quanto ha sofferto nostro signore
cristo ma con glenn o luisa tona bridson
e ac seppi vostro padre lo
soprannominano ac seppi san giuseppe
sarebbe abruzzo propriamente significa
ingiuriare però possiamo tradurre con lo
soprannominano teniamo presente che il
soprannome presso di noi era una forma
di offesa di ingiuria emanati i nonni
donda bacco sua madre raccoglie il
tabacco vedere qui
questo ti ci fa capire che la madre di
lei di e non la madre di lui fosse stata
la madre di lui avrebbero detto i ma
nato in ogni donna bacco poco cal 8 ener
c''ero il suo cranio e vuoto
anche qui l''ho accettata vendita doppia
tv coccolo propriamente e il cranio però
possiamo dire anche la sua testa è vuota
sinistro pezzetti fiera di lei o quella
ha ferito la sua mano tappe di ato di
nola con da i loro figli sono tutti
bassi bene adesso passiamo ad analizzare
le forme toniche degli aggettivi e pro
nomico ossessivi in questa tabella
vediamo il singolare in italiano
esso è mio tuo suo nostro vostro loro
per il maschile mia tua sua
nostra vostra loro eri femminile come
sappiamo in riva abbiamo anche il genere
neutro allora e di como di kimmo di como
di como per il maschile di kimmo per il
canile di como per il neo proprio come
vedete la prima parte di coop si
mantiene sempre uguale in tutta la
declinazione per il maschile cioè in
tutte e tre le persone singolari e
plurali del maschile e così pure per il
femminile di chi si mantiene sempre
uguale la parte mobile diciamo e il
celivo del pronome personale forma
aprono quindi mou che varia su mou per
indicare dio che il possesso e mio su
per indicare che il possesso e tuo tool
per il possesso tuo duo però riferito al
maschile di lui ti se il possesso il suo
però di lei quindi anche qui come per le
forme adone il gringo distinguesse suo
si riferisce a un nome maschile
oppure ha un nome femminile
abbiamo ma se il possesso è il nostro sa
se il possesso è vostro toh se possesso
e loro le stesse forme in cliniche si
ripetono anche per il femminile e per il
neutro quindi quello che cambia è la
prima barca dell''aggettivo o pronome
possessivo la desinenza della prima
parte quindi dico e lo un''altra cosa da
notare che la forma è in clinica viene
pronunciata e scritta raddoppiata in
quanto la 100 cade sull''ultima sillaba
sulla o quindi si pronuncia raddoppiata
lamu su atto e così via
adesso facciamo degli esempi
prendiamo un nome maschile un nome
femminile uno neutro per il maschile
prendiamo ad esempio il nome pacco che
significa nonno e il femminile atleti
che significa sorella per il neuro pd
che significa figlio allora diremo o
pacco di como mio nonno opap di kos tuo
nonno opap di cotto suo nonno di lui
il nonno di lui opap di kotti suo nonno
il nonno di lei
opap di com nostro nonno o vap di cossa
vostro nonno o patto di cotto il loro
nonno gli atleti la sorella e ha tre
figli di kim mia sorella
chi quindi ripeto ancora e la desinenza
del femminile e ha tre figli chisso tua
sorella
gli atleti di kiton sua sorella la
sorella di lui gli atleti di kitty sua
sorella la sorella di lei
gli atleti di kim nostra sorella e di
chissà vostra sorella ed i kit la loro
sorella di como toppe di di como
mio figlio dopo di di costo tuo figlio
dove di lì cotto suo figlio il figlio di
lui toppe di di kotti suo figlio di lei
giovedì di comma nostro figlio dove di
di cassa vostro figlio spediti cotto il
loro figlio
e qui di seguito vediamo degli esempi
tocco rafi di como e prometto di posso
certo di cotto il mio campo è più grande
del tuo e dell''oro qui vediamo
di como si ferisce accorati quindi fa da
aggettivo possessivo
qui invece di costo e di cotto sono dei
pro noi perché sostituiscono il nome
campo e dicati bicicletta di chisso
bicicletta femminile quindi di chisso
modiche eticista di kitty la traduzione
mi ha dato la sua cesta ci sta e
femminile quindi di chi ti lì lei la sua
di lei i clichè ospiti di cotto ha
chiuso la sua casa a casa di lui
ospiti di com te li ring meno la nostra
casa vuole imbiancata va in bianca da
teli significa vuole quindi di comma si
ferisce aspidi gunner roventi di com o
al pari di cotto e kimi a manca flamini
il loro cavallo a una gamba rotta anche
qui dovremmo pronunciare tuam pari però
ripeto e si usa la pronuncia oam pari ma
comunque pari è un nome neutro quindi
andrebbe pronunciato conto di cotto si
riferisce ad un pari che euro quindi la
o del neutro
dico questo in macchina di issa e prati
pleo pia chiede di indichino la vostra
macchina non cammina più
prendete la mia credi chissà gli kimmo
da notare che qui di chissà e aggettivo
perché sta
la macchina di chi invece sostituisce il
nome macchina quindi è un pronome
terremoto qui ti di como ortani la mia
chiave lidi n quindi di como di como e
di kimmo rintanen a polemizzare
i miei sono andati a lavorare in questo
caso di kim al significato di i miei
genitori i miei famigliari ed ora
passiamo al plurale vediamo dalla
tabella che li comodi kimmo di como è
diventato plurale e quindi è cambiata la
desinenza la o è diventata in rai è
diventata è del nord è diventata ha
quindi di kim per il maschile plurale di
che mou per il femminile plurale di
camus per il neuro l''orale
anche qui in tutte e tre le persone
singolari e plurali di chi si mantiene
sempre uguale e cambia il genitivo del
pronome personale quindi abbiamo di kim
di chi è mò di camus i kiss di cache di
tasso di quito suoi riferito a lui gli
chetto sue riferite sempre a lui di
catto riferite a lui suoi riferiva a lui
di kit i suoi riferito a lei di ketty
sue rivali lei di gatti suoi di lei poi
di kim nostri dijkema nostre di gamma
nostri di chissà vostri di chessa lost
di cassa vostri di quito loro dichetto
loro ricatto loro vediamo alcuni esempi
i patti di kimmo fatti maschile quindi
di kim i miei nonni e a 3d che mo le mie
sorelle a 3
femminile plurale di kim dae dia di
camus che dia neo proprio orale di camus
i papi di chisso i tuoi nonni tuoi in
questo caso è di chisso maschile plurale
gli hacker di che esso le due sorelle da
e di a picasso i tuoi figli
i tuoi bambini i papi di quito i suoi
nonni i suoi di lui gli altri di ketty
le sue sorelle sorelle di lui tappeti a
ricatto i suoi figli figli di lui i papi
di kitty i suoi nonni
i nonni di lei ea 33 di ketty le sue
sorelle le sorelle di lei strategia di
gatti i suoi figli i figli di lei
vediamo questi altri esempi al plurale i
papi di chi ma i nostri nonni ea 3 dic
emma le nostre sorelle tra via di calma
i nostri figli i papi di chissà i vostri
nonni ea 33 di chessa le vostre sorelle
tappe di a di cassa i vostri figli
i papi diritto i loro nonni di altre
fedi chetto le loro sorelle tappe di adk
i loro figli
bene questo è tutto comunque viene
spontanea
a questo punto una domanda e cioè quando
si usano le forme toniche e quando
invece le forme at one
in effetti non c''è una regola precisa
diciamo che ci si affida un po all''uso
comunque si usa la forma tonica quando
si vuole dare una particolare enfasi al
fatto che una cosa è mia tua sua
eccetera oppure quando c''è una certa
contrapposizione come nel caso di questa
frase topografi di como e plumbea a todi
posso certo di cotto allora il mio fondo
è più grande del tuo e dell''oro quindi
qua c''è la contrapposizione tra il mio
fondo è il tuo quindi non si usa la
forma tona ma chiusa dalla forma
tonica bene adesso non mi resta che
darvi appuntamento alla prossima lezione
che sarà sugli aggettivi e pronomi
indefiniti e concludiamo anche questa
volta con un proverbio o cucù bio un
giuda pedia tu e nè di no la civetta
come i suoi figli non c''è nessuno
prendendo lo spunto del regno animale
questo proverbio sottolinea quanto i
genitori
vogliano bene ai loro figli i quali
sembrano loro i più belli di tutti anche
se a volte non lo sono
ciao ciao', FALSE),
(11, 'NWsqcHqbUPk', 'Aggettivi e Pronomi Dimostrativi', 'pronomi_numerali', 'Pronomi & Numerali', '26:46', 2257, 'Declinazione completa di ''tutto/tuti/tuto'' (questo) e ''cino/cini/cino'' (quello). Carmine Greco illustra l''uso anaforico e deittico, le forme abbreviate e la sfumatura di vicinanza e lontananza.', '«Cino pu klétti to ''s addho, ''en echi mai kalò» — Chi ruba al prossimo non avrà mai pace né bene.', 'bene cari amici benvenuti a questa nuova
lezione di greco online è la quale
parleremo degli aggettivi e dei pronomi
dimostrativi ripetiamo brevemente nella
differenza tra aggettivo e pronome
l''aggettivo accompagna un nome per
aggiungerne una qualità o per meglio
determinarlo il pronome invece
sostituisce il nome vediamo in grembo
quali sono gli aggettivi dimostrativi
abbiamo d''uso to sit uso chiuso per il
maschile to see per il femminile tusa
per il neutro che si traduce in italiano
questo ho questa abbiamo poi ucciso
uccisi ucciso maschile femminile e neuro
che si traduce quello quella passiamo i
pronomi tuo lui tuo questo questa gino
gini chino quello quella e qui abbiamo
una tabella riassuntiva della
declinazione dell''aggettivo dimostrativo
d''uso to sit uso che traduciamo questo
questa non mi soffermo a leggere tutte
le voci della tabella in quanto lo
potete fare tranquillamente fermando il
video
elimino soltanto a dire che come avviene
per l''articolo per il nome e per
l''oggettivo qualificativo anche anche
l''aggettivo il pronome dimostrativo
hanno un uscita per il nominativo per il
genitivo dativo e accusativo ricordo che
il nominativo è il caso del soggetto
cioè di quella persona animale o cosa
che conti ad azione il genitivo è il
caso del complemento di
indicazione che risponde alla domanda di
chi di che cosa il da divo è il caso del
complimento di termine che risponde alla
domanda a chi sa che cosa e l''accusativo
è il caso del complemento oggetto che
riceve l''azione compiuta dal soggetto ed
espressa dal verbo
adesso vediamo alcuni esempi d''uso sacco
e ne può di vari questo sacco è molto
pesante
qui l''aggettivo d''uso accompagna il nome
sacco sacco e un nome maschile quindi
d''uso e il nominativo maschile singolare
perché sacco fa da soggetto tunis ora è
mukhina pole e viso a quest''ora non mi
va di lavorare tunis ora è il genitivo
femminile singolare perché ora è
femminile stia semo tutti seggiano
aggiusta mi questa sedia tutti se già è
caso accusativo perché è un complemento
oggetto quindi qua c''è la vostra perché
cade la n
davanti alla s di seggio che è una
consonante sorda tutti quindi accusativo
femminile singolare tutti su dieci non
accuso lutri a questa domenica vado ad
ascoltare la santa messa
tutti giulia ci crediamo che qui cade
anche la n dell''accusa vivo perché
analizzando la frase il soggetto della
frase io vado a sentire messa tutti
giulia c è un completo
di tempo determinato quindi richiede il
caso accusa vivo
siccome celiaci e femminile tutti è
questa qui caso accusativo femminile
singolare tulisa tutto arnad ci ho
venduto questo agnellino arnad c è un
nome neutro
tutto è il caso accusativo neutro
singolare via tipo di sé tutto nappi
razzo perché hai annaffiato questo pero
selvatico
ap razzo e un nome maschile quindi
vediamo qui la n dell''accusa divo
maschile singolare tutto cio bros
opportuno cristiano e mi piace e il viso
di questa persona non mi piace to know
cristiano di questa persona di chi è un
complemento di specificazione quindi tu
no
e il caso del genitivo maschile
singolare da tener presente che in griko
generalmente si usa quest altra
espressione anziché dire tu nu cristiano
si dice più comunemente a sé tutto
cristiano in questo caso tutto è
accusativo maschile singolare maschile
perché cristiano il maschile è l''accusa
di verdetto dalla preposizione a tutto
il libro tu come l''eti solo questo libro
qui l''ho letto tutto libro è un nome
maschile tutto c''è una bosco della n che
cade da tener presente che
tucson e anche come vedremo ucciso che
significa quello può essere rafforzato
dalla particella tu che significa qui si
doveva scrivere con lei davanti eto''o
eto''o però generalmente per line non si
fa sentire
quindi questa particella non sempre si
metta è facoltativa si metta quando si
vuole rafforzare un po l''idea di questo
il concetto di questo questo libro qui
da tener presente che quando tutto va da
attivo tu si mette dopo il nome tutto il
libro tu come ladies a polo
quindi questo libro qui l''ho letto tutto
però ripeto ancora questa particella si
può anche ammettere che tu non spedì a
bastad una città di a questi ragazzi di
stare zitti un oste dio è il caso dativo
a chi a questi ragazzi
quindi è dio è un nome neutro quindi tu
no
il caso dativo neutro plurale
da tener presente che città in questo
caso è un aggettivo che significa zitti
cela del neutro perché si riferisce a te
dio che è un nome neutro o chris thomas
ca tali se ne tutte sull''abile saprai
era gesù ci ha rovinato con queste
pietre dal cielo tutte si riferisce alla
fides che è un nome femminile è un caso
accusativo retto da me quindi a cui
salivo femminile plurale tutte
adesso passiamo ad analizzare il pronome
dimostrativo tuo lui tuo dopo aver dato
uno sguardo alla tabella sinottica e
letto le varie voci
andiamo a vedere alcuni esempi o furno
di como e plumbea il ritmo il mio forno
è più grande di questo turno è un nome
maschile tuo si riferisce a forno
sostituisce il nome furno quindi è
maschile singolare lui è nono a tipo di
asti nice day questa non capisce niente
lasciala stare lui è soggetto quindi
nominativo femminile singolare lui lui è
na non è tipo di questi non capiscono
niente vediamo la differenza tra le due
frasi la prima e la seconda lui e tui
tui capiamo che è nominativo femminile
singolare perché il verbo è una terza
persona singolare quindi tuoi è il
nominativo questa costei possiamo anche
dire costei non capisce niente
nella seconda frase invece il verbo e
plurale terza persona plurale
quindi i tuoi è il nominativo maschile
plurale questi costoro non capiscono
niente e di katun in acqua ripam bacerò
oppure possiamo dire se cottura
ho dato a questa un gomitolo di cotone
duni a chi ha questa naturalmente ci
riferiamo a un nome femminile tuni tu e
tu mi piace one nastri queste qua mi
piacciono un po vedete che qua 2 e
rafforzato dall''avverbio tu queste qui
in questo caso la particella
rafforzativa tu è messa immediatamente
dopo il pronome due to i da due caprino
netta madia ho visto queste che lavavano
i capelli 2
che cosa 2 complemento oggetto è un
acquisitivo femminile plurale 2 investa
tu no è fiorita la veste di costoro e
fiori da o di queste di queste riferito
a un nome femminile e quindi tu no
poteva essere anche un nome neutro o
maschile però visto che stiamo parlando
di veste è chiaro che si riferisce a un
nome femminile tua to enough e lune leo
queste qua
anche qui c''è il rafforzativo tu non
servono più
abbiamo prodotto queste ma potevamo
tradurre anche questi perché tua è un
neutro e quindi in italiano può
riferirsi sia con nome maschile sia
femminile nanì in valeee cito scarso
vale tutu caio
non mettere quei pantaloni metti questi
meglio
metti che cosa questi siccome scarso è
un nome maschile tutu è un maschilismo
accusa vivo potevamo anche dire vale
tutto sardo etti questi altri
e qui vediamo l''aggettivo dimostrativo
ucciso ci si uccise che corrisponde all
italiano quello quella passiamo subito a
vedere degli esempi uccisi di neka c è
né i petter a su quella donna li e tua
suocera
vedete che ci si sa ci tra parentesi
quindi si può anche dire sì nei calci e
nei letterato e c''è tra parentesi anche
l''avverbio un rafforzativo c con
l''apostrofo perché deriva da easy che
significa lì la si può mettere come pure
non si può mettere quindi posso dire sì
chi nega e nei metterà su uccisi nega e
nei petrasso oppure cisi in e caci e nei
metterà su cissokho rafi e plumbea
pillitu a quel campo è più grande di
questo ucciso e aggettivo dimostrativo
neutro singolare perché corapi e un nome
neutro e deciso e questo in altri one
mai ci tocco rati non erano mai quel
campo anche qui
corapi al nome neutro città e caso
accusativo perché fa da complemento
oggetto non erano mai che cosa quel
campo quindi cito è un caso accusativo
neutro singolare fitto tories e teen
donata e ci toria madia oppure me ct
norian festa
allora hai visto donata con quei bei
capelli ma di an euro plurale caso
accusativo retto da me quindi città che
viene apostrofato quanti a parola
cominciate largo galli quindi caso
accusativo neutro plurale eccolo se
avessimo detto mesi di nori am best a
testa invece è nome femminile 15 teen è
un caso accusativo femminile singolare
perché si accorda con il nome femminile
resta kittin i su piante zitte su co2
tu hai piantato quei figli o questi
quindi sushi è un nome femminile plurale
quindi cites caso accusativo perché fa
da complemento il centro il soggetto è i
su che cosa hai piantato quei figli
quindi complemento oggetto cites
quindi è caso accusativo femminile
plurale questa qua o 22 in questo caso è
un pronome dimostrativo o queste
abbiamo già visto ne cito sun provo
nomine kim haiti cani con gli uomini non
avere mai a che fare qui ci provo
abbiamo un caso accusativo plurale retta
da la reposizione ne provo è maschile 15
tus sarebbe questo i franza cinue angolo
ei podi andrà da la fronda di
quell''albero ha molta infiorescenza fino
al ghul complemento di specificazione di
quell''albero 15 no è un aggettivo che si
accorda col maschile angolo è un
incentivo maschile singolare chino
potevamo dire anche ed è anche questa
una espressione più comune fc tona ruolo
in questo caso a se reggerà accusativo
cheat on
è il caso accusativo maschile singolare
keaton vale ancora it on a stick o fai
attenzione a quel pavimento astico è un
nome maschile e caso accusativo keaton
si pronunciano n perché la parola
incomincia per vocale città prama da età
sotto risi quelle cose non le posso
vedere ramada è neutro plurale città è
un accusativo neuro plurale città
il soggetto e io non posso vedere che
cosa quelle cose caso applicativo
neuro plurale ed eccoci arrivati al
pronome dimostrativo chino chini chino
che si traduce quello quella da notare
che ci nocini chino può essere anche
pronome personale come vedremo in una
prossima lezione
vediamo ora degli esempi chino e nena
calo cristiano
quella è una brava persona
cino si riferisce a cristiano che un
nome maschile quindi maschile singolare
chino calò ha propriamente significa
buono però possiamo produrre anche una
brava persona d''uso tarlo c.to enea si
meglio ci noci cruz a segno questo
orologio qua e d''argento quello la d''oro
allora vediamo che qui abbiamo
l''aggettivo dimostrativo d''uso che
accompagna il nome carlo c e c''è anche
il rafforzativo tu questo orologio qua
per quanto riguarda il pronome anche qui
abbiamo chino ci abbiamo l''avverbio che
rafforza il pronome quello là da tener
presente che ha sì meglio propriamente
significa argenteo e cruz a segno aureo
però possiamo tradurre anche di argento
ed oro
da notare ancora che la particella
rafforzativa quando c''è l''aggettivo
dimostrativo si mette dopo il nome d''uso
carlo c.to mentre se c''è il pronome la
particella rafforzativa si mette
immediatamente dopo il pronome da corapi
acino i nolani carica
i campi di quello sono tutti incolti di
chi di quello chino quindi e genitivo
singolare maschile
oppure neutro cin cin ho riferito sia a
noi maschi le sia a 9 euro
buffon è decaduto limbo e nei cieli è
vicino
mi sembra che questo casino e di quella
non di quello di chi di quella cini e
questo il genitivo singolare chino
invece di quello maschile o neutro
singolare di famiglia ci no perché the
hub martana
la famiglia di quelli viene da martano
attenzione si no vale sia per il
maschile per il femminile per il nero
quindi possiamo dire di quelli o di
quelle tories e città petia cina in
tappeti a kiss dito nissa hai visto quei
ragazzi quelli sono i figli della vicina
di casa cina si riferisce a pedia che è
neuro plurale quindicina nominativo
neutro l''orale cina di aver presente che
pedia ha due significati quello di
ragazzi bambini anche quello di figli ci
noto se diga mia scoccola va a quelli ho
dato una sberla a chi si no quindi da
divo plurale può essere a quelli anche
quel c no occorre riferito a nome neutro
sempre a quelli da noi fronti ci no
comuque lezione desalle e checa da un
fulmine a quelli che mi hanno rubato le
olive
si no anche qui a chi a quelli può
essere anche a quel che vale anche per
il genitivo femminile plurale
propriamente fronti significativo però
abbiamo prodotto con questa espressione
piega da un fulmine ma tutta scalia to
vale da solo fini cina ci si ponga ecco
questi fichi secchi qua
mettili nel paniere quelli là in tasca
anche qui vediamo che abbiamo
l''aggettivo dimostrativo tutta e il
rafforzativo tool messo dopo il nome
asca di perché tutta e in questo caso
aggettivo cina ci quelli là in tasca
quelli è pronome quindi il rafforzativo
ci si mette subito dopo il nome bene
penso di aver dato una panoramica
completa dell''aggettivo e pronome
dimostrativo e quindi ci vediamo alla
prossima lezione comunque prima voglio
concludere con un proverbio chino puc
letti tosato e nei mai calo
chi ruba agli altri non ha mai bene
ciao a tutti', FALSE),
(12, 'wzTot2RZznQ', 'Aggettivi e Pronomi Indefiniti', 'pronomi_numerali', 'Pronomi & Numerali', '19:21', 1689, 'Rassegna dei quantificatori e indefiniti fondamentali: ''kané / kanéddha'' (nessuno/qualcuno), ''olo'' (tutto), ''posso'' (quanto), ''kàsso'' (ciascuno) e ''addho'' (altro), con tabelle di concordanza.', '«Echi ti psiddha sti vesta» — Ha la pulce nella veste (si dice di chi non trova mai quiete).', 'allora cari amici benvenuti a questa
nuova lezione nella quale parleremo
degli aggettivi e pronomi indefiniti
li vediamo in questa slide e sono tutti
sia aggettivi si aprono mi ad eccezione
di passo passi passo evidenziato in
azzurro che è solamente aggettivo
ricordo a chi avesse perso qualche
precedente elezione la differenza che
esiste tra aggettivo e pronome
l''aggettivo accompagna il nome per
raggiungere una qualità cover medio
determinarlo mentre il pronome
sostituisce il noi vediamo in breve
quali sono gli aggettivi e pronomi
indefiniti
incominciamo da una mia pena che si
traduce 1 oppure un tale una tale è una
nostra vecchia conoscenza perché è
uguale all''articolo indeterminativo e al
numerale cardinale poi abbiamo canina
cammina cammina canina al maschile camia
femminile caneva al neutro può essere
aggettivo pronome però ha un doppio
significato se lo troviamo in una frase
negativa ha il significato di nessuno se
invece si trova in una frase affermativa
ha il significato di qualche o qualcuno
qualche in genere se fa da aggettivo
qualcuno se fa da pronome facciamo
qualche esempio
allora il tè è na na né brighi è venuto
un tale a trovarmi facciamo un esempio
con caneva e di dacca nena sei mesi non
ho visto nessuno in piazza è una frase
negativa e quindi ha il significato di
nessuno
in una frase affermativa diremo
i da camera sei mesi ho visto qualcuno
in piazza se fa ad aggettivi diremo ida
cane cristiano si mesi ho visto qualche
persona in piazza adesso che stiamo h
possa vediamo che è mentre è na e camera
hanno soltanto il singolare
d''altra parte anche in italiano uno non
si può dire al plurale e anche nessuno
non possiamo dire certamente nessuno
quindi solo singolare lo stesso avviene
in griko mentre verga possa abbiamo
oltre al maschile che mira il neopro
abbiamo anche il singolare e il plurale
quindi come si traduce si traduce con
tanto ho parecchio tanto tanta parecchio
parecchia eccetera
allora che possono tanta gente pieno e
maschile quindi che ha posto ieri
capozzi cristiani tante persone maschile
plurale cappussi stati tanta cenere
stati è un nome femminile quindi fossi
stati carta genere kappos linee che
tante donne kappos allegri allegri a
nome neutro quindi cappotto allegri
tanta farina cup ossa e di a tanti
ragazzi ma posso anche dire parecchi
ragazzi parecchia farina parecchia gente
parecchie versare passiamo acqua e conai
e aggettivo o pronome che ha sempre la
stessa desinenza sera il maschile sia
per il femminile che sia per il neuro
anche per il singolare e il plurale
in azione la desinenza sempre e come si
traduce si traduce con ogni un tale
certo irto nei guai number icone sono
venuti alcuni a trovarmi oppure posso
dire qua i pedi irte nome brighi incerto
ragazzo è venuto a trovarmi passo passi
passo abbiamo detto fa soltanto da
aggettivo quindi non può essere un
pronome corrisponde all italiano ciascun
o ciascuna ed ogni passo cristiano e
gina problema ogni persona ha un
problema oppure passi li nega passi
cristiani oppure passo pd quindi ogni
oppure ciascuno poi andiamo a oro che ha
una terminazione per il maschile
femminile in neuro una regolare è una
rev il plurale diremo o lo toglierò
tutta la gente pieno in maschile
videocolor oli i cristiani cristiani e
maschile plurale oli oli gli stati
tutta la cenere oli stati abbiamo detto
e femminile o le tesi di nega tutte le
donne o le polo tale bri tutta la farina
o la trap e di a tutti i ragazzi a lio
pieno
poca gente al i cristiani poche persone
alia stati poca ce n''era ali e linee che
poche donne a lio allegri poca farina a
lia e di a pochi bambini
oggi i ragazzi lo stesso vale per poi di
quelli che significa molto ad ha chiesto
una residenza per il maschile femminile
e neuro una per il singolare è una per
il plurale si traduce altro altri però
nel senso di un altro diverso userò ad
se dico per esempio e telo duo te lo do
nardò non voglio questo voglio l''altro
l''altro che è diverso da questo
perché se voglio dire un arco voglio un
altro ancora
userò il pronome a donerà che vedremo
nella successiva slide e adesso vediamo
alcuni esempi irpe enac a i tele nanì
lisi mese na è venuto un tale che voleva
parlare con te in questo caso è na ha il
significato di uno un certo un tale eni
che cammina gli nega cena crisi a non
c''era nessuna donna in chiesa quindi
vedete che questa è una frase negativa
che c''è e non cambia anzi galdi nessuna
nessuna donna si mesi i bric amo cane
cristiano in piazza
abbiamo provato qualche persona questa è
una frase
affermativa quindi cane fa da aggettivo
perché sta accanto al nome cristiano e
ha il significato di qualche tipo mini
samek amena ma buffet mede cai su amy
lee ce ne camera oppure medino allora io
ho parlato con qualcuno ma mi sembra che
tu non hai parlato con nessuno che
succede che qui gli uomini same camera
ci troviamo in una frase affermativa io
ho parlato con qualcuno
nell''altra frase mi sembra che tu non
hai parlato con nessuno c''è il non è
quindi ci troviamo in una frase negativa
canina si traduce nessuno si poteva dire
anche oltre che nei caneva anche emily
se metti know it ameglia meno che posso
allegri è andata buttata tanta farina ho
parecchia farina cappotto è un aggettivo
e quindi tanta carina ho parecchia
farina quali forè e sano certe volte non
ti capisco guai
l''aggettivo perché staccata fare e ha il
significato di certo certe volte il tan
è quais ostili mo nun ebrico ne sono
venuti certi a casa mia a trovarmi
quindi guai a il significato di certi
certe persone dei tali
a settimana a gava da pedia di ogni
mamma ama i suoi figli passi e aggettivo
accompagna la parola ma umana quindi
ogni linea ninni animi a all è immane e
coppe di a questo è un verso di una
ninna nanna significa una nanna ninna
nanna ninna nanna tutte le mamme hanno
figli o le immane pole fa aggettivo al 9
ma ne quindi è femminile plurale o le
suite o lucino cui cana giudizo allora
ti ho mostrato tutto quello che avevo da
mostrarti o che ti dovevo mostrare o lo
tutto inusuali e alle credo ho raccolto
poche olive quest''anno ali aggettivo di
del nome al femminile plurale cordone m
a lio e provo di disagio con il poco non
mangio molto qui abbiamo due pronomi al
io poco e o dvd è anch''esso un pronome
ed è questo o di euro singolare tuo
eto''o telo da una nato questo non lo
voglio darmi un altro un altro però nel
senso di diverso
non nel senso di un altro
ancora da me un altro cioè diverso dal
primo
se devo dire dammi un altro ancora
dirò adone na lo vedremo nella
successiva
ed eccoci arrivati all''ultima delle
nostre diapositive sugli aggettivi e
pronomi definiti quelli che vediamo qui
in questa diapositiva sono soltanto
ronnie cioè non possono fare da
aggettivi
essi sono ispo di no tipo di passo mena
adone na allora per quanto riguarda gli
sputi no e tipo di sono indeclinabili e
per questi pronomi diciamo quello che
abbiamo detto per canina per l''aggettivo
e pronome camera della diapositiva
precedente e cioè che se si trovano in
frasi affermative o interrogative hanno
il significato di qualcuno qualcuno
qualcosa
se invece si trovano in frasi negative
hanno il significato di nessuno nessuno
niente vedremo poi degli esempi poi
abbiamo passo mena massimi a passo nena
quindi una forma per il maschile uno
femminile una per il che significa
ciascuno oppure ognuno e adone na sa di
mia adone ma che significa un altro
un''altra ancora non un altro nel senso
di diverso ma un altro
in aggiunta a qualcosa di prima vediamo
degli esempi irte di spokane iter è
venuto qualcuno che mi voleva ci
troviamo in una frase interrogativa ha
il significato di qualcuno
qui invece eni rté dispo non è vero
nessuno siamo in una frase negativa
quindi di sport ha il significato di
nessuno
da tener presente che dispo si usa solo
quando fa da soggetto sia qui sia qui
disposta da soggetto vediamo alla frase
successiva eni da tino sei mesi
attenzione potevo dire anche egli da
camera si mesi non ho visto nessuno in
piazza siamo in una frase negativa
quindi di no ha il significato di
nessuno non uso di spuma userò di no
perché in questo caso è un complemento
oggetto fosse stato soggetto avrei usato
dispo idee di no
sì mesi siamo in una frase interrogativa
non è una frase negativa quindi ha il
significato di qualcuno hai visto
qualcuno in piazza se a rodi saani che
tipo dinamo dory cei su nuove carene il
tipo di dio chiesto se c''era qualcosa da
darmi e tu mi hai detto che non c''era
niente quindi vedere che tipo di si
trova una frase affermativa e abbiamo
prodotto qualcosa invece qui mi hai
detto che non c''era niente siamo in una
frase negativa e quindi anzi grado di
niente passa meno accesa retina stadi a
corto ciascuno di voi
bisogna che stia attento hassanain a
ciascuno
anche ognuno di voi lo stesso kamen ambi
adone na fai entrare un altro qui ha il
significato di un altro ancora
quindi userò adone na il pronome adone
va a di mia a domani nell''ultima frase
invece telo caio tutto nardò voglio
meglio quest''altro altro qua ha il
significato di diverso un altro diverso
dal primo
quindi userò l''aggettivo o pronome ad
bene allora questo è tutto
vi do appuntamento alla prossima
versione nella quale parleremo degli
aggettivi e pronomi interrogativi vi
saluto anche questa volta con un
proverbio passo sito indenni si
raffredda ogni pool c entra nell''orlo
della veste con questo proverbio si
allude a quelle persone che si
incrociavano dappertutto come le pulci
ciao a tutti', FALSE),
(13, 'fs2z_en6mIw', 'I Numerali Cardinali e Ordinali', 'pronomi_numerali', 'Pronomi & Numerali', '25:07', 1956, 'Studio dei numeri cardinali da uno a mille con focus sui primi quattro che declinano il genere (''ena/mia, dyo, tria/tris, tessera/tessaris''), seguiti dalla formazione degli ordinali e dei frazionari.', '«Tessera matti vlepune plon kalò para dyo» — Quattro occhi vedono meglio di due (il consiglio fraterno è sempre prezioso).', 'cari amici benvenuti a questa nuova
lezione dove parleremo degli aggettivi
determinativi innanzitutto facciamo una
piccola premessa dicendo che gli
aggettivi si distingue in aggettivi
qualificativi e aggettivi determinativi
qual è la differenza
gli aggettivi qualificativi aggiungono
una qualità al nome che accompagnano
mentre gli aggettivi determinativi
aggiungono una determinazione
un''indicazione che può essere di vario
tipo al nome che accompagnano gli
aggettivi determinativi sono numerali
ossessivi dimostrativi interrogativi
indefiniti esclamativi ad esempio è na
dio atri a 123 sono aggettivi numerali
ossessivi di como di costo di cotto io
tu suo dimostrativi alcuni sono tuo uso
chino questo quello interrogativi tease
di esclamativi indefiniti cane nacua ed
altri che vedremo poi in seguito
dobbiamo aggiungere che gli aggettivi
determinativi vengono considerati
aggettivi nel momento in cui
accompagnano in nome invece pronomi se
sostituiscono il nome facciamo un
esempio se io dico questo libro è più
interessante di quello questo è
aggiuntivo perché sta accanto al nome
libro quello invece è pronome perché
sostituisce il nome libro degli
aggettivi qualificativi abbiamo parlato
in altre lesioni mentre qui in
cominceremo a trattare gli aggettivi e
profondi determinativi incominciando
dagli aggettivi e pronomi numerati
bene osservando questa tabella di world
tour
notiamo che i numerari si distinguono in
numerari cardinali ordinali
moltiplicativi collettivi e distributivi
incominciamo dai numerari cardinali
vediamo che nella colonna a sinistra ci
sono i numeri arabi e a fianco la
traduzione in griko allora uno si dice
in griko pena per il maschile mia x
femminile e na per il neo trophy il
numero 2 dio indeclinabile il 3
kris kris kris per il maschile e
femminile tria per i nomi neutri il 4
tessari testare e sarà può avere anche
l''acqua saliva tessa ross e sareste sarà
5 pente 6 ed il 7 ita 889 in ne ha 10
deca 11 and ca12 dodeca 13 deca through
the cat ria
le catherine maschile e femminile the
cat ria per il neutro deca tessari the
cat essere the cat e sarà il 14
anche qui abbiamo maschile femminile e
neuro come l''aggettivo tessari essere te
sarà poi 15 decadente 16 de cazze 17 de
cata 18 de cappotto 19 deca in ne ha
venti i così il 21 kiko siena chi così
mia ico siena perché formato dai così
più è na
sappiamo già che è na si declina in
questo modo e nomi aena
quindi
che il 21 e ico siena e così via
e''così era il 30 30 il 31 creante nat
realta mi atri antena oppure piantana 40
taranta 50 70 60 a cinta 70 admenta 80
bogdanka 90 hanno vinta cento a kato
dobbiamo dire che la n si fa sentire
davanti a nome cominciate per vocale o
per consonante media come la di di
domodossola di venezia la g di genova
l''abi di bologna mentre si fa sentire
davanti alle altre consonanti cento è
uno pagato ne va a casa mia a catone ma
naturalmente se dovessimo dire 41 42 43
oppure 51 52 53 diremmo santa e na santa
mia sarà una taranta dio saran tatry
serata tria taranta tessera e così via
sesso per petita per tinta e 9 petita
dio oppure per tinta tria per tinta
destra
eccetera eccetera quindi notiamo che la
nda catonne si fa sentire
davanti al e nnamaka drone ma così pure
cento e due si dice a caton dio fa
sentire per la pronuncia alla n
e chiaro che se dovessimo dire cento e 4
dire no a cadute sarà senza la m200 di
rossi 300 tra costi e 400 e sarà così a
530 cossi 600
ossia 700 it up ossia 808 costi a 900m
agossi a mille si dice figlia 2000 di
oki chiave 10.000 decq archiviate e così
via
da tener presente che chi kyat è
propriamente significa migliaia 2
migliaia come vedremo
mia figlia da è un aggettivo collettivo
quindi se dobbiamo dire ad esempio 2020
diremo dio gigliate
e così se dobbiamo indicare una data ad
esempio 1949 diremmo figlie e ne ha
costi e sar anta in ne ha adesso diamo
un rapido sguardo agli altri numerali
vediamo quali sono i numerari ordinali
abbiamo soltanto protino rotini prodi no
proprio no maschile proteine femminile
protino neutro che significa primo poi
in sostanza non abbiamo altri però
abbiamo i nomi dei giorni della
settimana che sarebbero numerali
ordinari ad esempio lettera treaty tetra
tipetti lunedì martedì mercoledì giovedì
in realtà detterà significa
letteralmente secondo al giorno
anche perché la settimana in cominciare
da domenica quindi il lunedì è il
secondo giorno lettera riti e il martedì
terzo giorno terrati il mercoledì quarto
giorno betti e il giovedì quinto giorno
della settimana archi ordinali non
esistono i moltiplicativi moltiplicativi
abbiamo soltanto in griko man and co e
significa solo
ed i blog che significa doppio
collettivi abbiamo gigliata significa
migliaio giocari che significa coppia
centenari significa un centinaio
come abbiamo già detto prima per dire
2000 si dice dio gigliate che sarebbe
propriamente 2
migliaia i distributivi si usano nei
seguenti modi il sena sena ad uno ad uno
oppure è na jana uno per ciascuno oppure
è nati for a uno alla volta e così anche
per tutti gli altri numerali quindi
ricapitolando una mia è na che significa
uno si declina come l''articolo
indeterminativo ad esempio autorità
mappe di todi samia in chi nega poi tris
tria a una sola forma per il maschile
femminile ed una per il neutro come
abbiamo già detto ad esempio kris lang
propri chris di meg e tria pedia tre
uomini e tre donne tre ragazzi da sd
tris si pronuncia davanti al locale o
consonante media come la dc di chi nega
la v di venezia la di di domodossola
labili bologna però non si fa sentire
davanti a consonante sorda ptk lsr ad
esempio 3 muri di demo critichi paese
anzi fa sentire tessalit essere e sarà
anche l''accusa vivo stessa rus essere e
sarà l''uomo sa tessaro sacco ho riempito
quattro sacchi il numero 31 si pronuncia
si pianta è na cantami atri antenne
come pure abbiamo già detto sì a
piantana pianta mia piantana e così pure
il 41
sarà un treno o taranta ma a kato quindi
prende una n dinanzi a parole cominciati
per vocale o consonante media agi kabul
di la b mentre se la parola che esegue
comincia peraltro consonante questa
viene pronunciata raddoppiata diremo
quindi a kut romena si fa sentire la n a
ca tron dio si fa sentire la n a catania
oa cadute sarà non si fa più sentire
adesso vediamo come si usano gli
aggettivi numerali per indicare le ore
per indicare i giorni del mese per gli
anni per la percentuale eccetera
quindi per indicare le ore di remo sisde
ca alle 10 si mia all''una se dio alle 2
e cederà
da notare che la preposizione articolata
sesso è formata dall as che deriva
dall''antico greco ace che significa a e
test che è l''articolo femminile plurale
quindi corrisponde all italiano alle da
tener presente che noi a sternatia
diciamo sesso però in altri paesi si
dice stessa così pure si mia a sternatia
stimi a in altri paesi della grecìa
salentina
vediamo per indicare i giorni del mese
si prodighi mera aprile il primo di
aprile nera significa ciò però è un nome
che possiamo anche omettere possiamo
dire sì provini mera aprili vo
oppure si prodighi aprivo il primo di
aprile il primo giorno di aprile
prodi né nere aprivo i primi giorni di
aprile
oppure i primi di aprile
se sente gatto agosto l''undici di agosto
se stessa retto ma io il 4 di maggio
vediamo le espressioni che si usano per
indicare gli anni toki ea così il 2020
oppure si può dire nel 2020 è una
indicazione di tempo i tool e narrano
fra un anno letteralmente sarebbe da qui
a un anno
e tu deca crono fra dieci anni
vediamo per la percentuale deca passa
katoh 10 per cento sarebbe letteralmente
10 ogni cento vediamo come si esprimono
le operazioni aritmetiche in griko
allora diremo in uso per il maschile in
i saperi femminile chimico per il neopro
per dire la metà ad esempio i mis en ora
mezz''ora qui c''è la n perché la parola
che serve comincia per votare quindi si
fa sentire questa n i miss ha proceduto
è femminile per che accompagna il nome
femminile
ora vediamo come si esprime in griko la
somma dio c''è dio due più due
letteralmente sarebbe 2 e 2 per la
sottrazione ha sede ca
io ne pente 10 meno 5 letteralmente
sarebbe da 10 togli
5 per la moltiplicazione tria io te sarà
3x4 per la divisione tessara tamer azzam
è il dio 4 diviso a due letteralmente
sarebbe 4 lo dividiamo per due bene
abbiamo concluso per questa lezione
vi do appuntamento alla prossima in cui
tratteremo gli aggettivi pronomi
dimostrativi concludiamo con un
proverbio tessara a madia torun e pleo
piri dio quattro occhi vedono meglio di
due vuol dire che a volte dobbiamo
avvalerci anche dell''aiuto degli altri
ciao ciao a tutti
adesso vediamo come si usano gli
aggettivi numerali per indicare le ore
per indicare i giorni del mese per gli
anni per la percentuale eccetera
quindi per indicare le ore diremo se
deca alle 10 si mia all''una
se dio alle 2 e cederà da notare che la
preposizione articolata ses è formata
dall as che deriva dall''antico greco e
il che significa a e test che è
l''articolo femminile plurale quindi
corrisponde all italiano alle da tener
presente che noi a sternatia diciamo
sesso però in altri paesi si dice stessa
così pure si mia ha strappati a sti mia
in altri paesi della grecìa salentina
vediamo per indicare i giorni del mese
si prodighi mera aprile il primo di
aprile nera significa giorno quindi però
è un nome che possiamo anche omettere
possiamo dire sì provini mera aprili vo
oppure si provini aprivo il primo di
aprile il primo giorno di aprile
se prodi né neve arrivo i primi giorni
di aprile
oppure i primi di aprile
se sente gatto agosto
l''undici di agosto se stessa e tu ma io
il 4 di maggio
vediamo le espressioni che si possono
avere indicare gli anni
pochi gli così il 2020
oppure si può dire nel
il 2020 è una indicazione di tempo i
tool è na trono fra un anno
letteralmente sarebbe da qui a un anno
e tu dica trono fra dieci anni
vediamo per la percentuale
deca passa kato 10 per cento sarebbe
letteralmente 10 ogni cento
vediamo come si esprimono le operazioni
aritmetiche in griko allora diremo in
uso per il maschile in i saperi
femminile chimico per il neutro per dire
la metà ad esempio in his anora mezz''ora
qui c''è la n perché la parola che segue
incomincia vergonare quindi si fa
sentire questa n
chi mi sa che tutto è che mi nile che
accompagna il nome femminile
ora vediamo come si esprime in griko la
somma dio c''è dio due più due
letteralmente sarebbe 2 e 2 per la
sottrazione accede ca
io ne pente 10 meno 5 letteralmente
sarebbe da 10 togli nei cinque per la
moltiplicazione ria
io te sarà 3x4 per la divisione tessara
tamer anza me il dio 4 diviso a due
letteralmente sarebbe 4 lo dividiamo per
due bene abbiamo concluso per questa
lezione
vi do appuntamento al
prossima in cui tratteremo gli aggettivi
pronomi dimostrativi concludiamo con un
proverbio tessara a madia torun e pleo
piri dio quattro occhi vedono meglio di
due vuol dire che a volte dobbiamo
avvalerci anche dell''aiuto degli altri
ciao ciao a tutti', FALSE),
(14, 'fOZxkr35OAs', 'I Pronomi Personali Soggetto e Complemento', 'pronomi_numerali', 'Pronomi & Numerali', '26:55', 2391, 'Quadro sinottico delle forme toniche (''egò, esù, ecìno'') e delle particelle clitiche dirette e indirette (''me, se, ton, tin, mas, sas, tus''). Regole sintattiche di proclisi ed enclisi rispetto al verbo.', '«Egò leo to diko-mu ce esù kuse to diko-su» — Io dico il mio sentire e tu ascolta il tuo cuore.', 'cari amici benvenuti a questa nuova
lezione nella quale parleremo del
pronome personale
incominciamo subito e analizziamo la
prima persona come sappiamo
dall''italiano il pronome personale a tre
persone prima seconda e terza singolare
e plurale io tu e gli noi voi essi
quindi equa incominciamo a vedere la
prima persona come si traduce in griko
io al singolare e noi al plurale
innanzitutto dobbiamo dire che come in
italiano ci sono le forme toniche cioè
accentate e le forme adone cioè senza
accento la stessa cosa viene anche in
griko le forme adone sono quelle che non
hanno un accento proprio maschi
appoggiano alla parola che precede e
quindi si chiamano en critiche o alla
parola che segue
e quindi si chiamano pro critiche ad
esempio se io uso la particella
pronominale mi dico
dimmi il mesi appoggia alla parola che
precede e quindi è una en critica
se invece dico mi dici il mese approccio
alla parola che segue è quindi una pro
critica la stessa cosa avviene anche in
griko se io dico fermo il mo si appoggia
alla parola che precede quindi è in
clinica
se dico invece mou lei mi dici ill.mo si
appoggia alla parola che segue
ed è una pro critica
adesso però vediamo il pronome personale
nei particolari
allora per la prima persona singolare
abbiamo in griko ivo
che corrisponde all italiano io e alla
prima persona plurale fini che
corrisponde all italiano noi
ivo aimee si usa soltanto quando hanno
la funzione di soggetto cioè quando la
persona compie l''azione nei complementi
invece si usa la forma e mena per il
singolare e ma per il plurale quindi se
devo dire di me complemento di
specificazione di rojas e mena
se devo dire a me kiss me na se è invece
un complemento oggetto mena o e mena al
plurale quindi soggetto in sé ma di noi
ima visse ma a noi i ma noi complemento
progetto per quanto riguarda le le forme
ad ore
abbiamo quindi corrispondono italiano mi
m come complemento oggetto che
corrisponde sempre l''italiano mi mi ha
detto ha detto a me mi ha provato ha
trovato me in italiano abbiamo sempre mi
in grillo invece c''è un complemento di
termine sarà mou se è un complimento
oggetto sarà né un discorso a parte va
fatto al mou è il complemento di
specificazione che si usa come aggettivo
possessivo
questo lo abbiamo detto quando abbiamo
parlato degli aggettivi possessivi in
realtà questa forma e in clinica del
pronome personale significa di me però
si usa come mio si traduce come mio
allora se io dico opap homo mio nonno
sarebbe letteralmente il nonno di me
quindi mio nonno per quel che riguarda
la prima persona plurale le forme e
critiche sono ci sia per il compimento
di termine e sia per il corpo nel
progetto
lo stesso discorso che abbiamo fatto che
il complemento di specificazione al
singolare quale anche per il plurale
quindi ma significa nostro sarebbe di
noi nostro papà coma nostro nonno il
nonno di noi e adesso vediamo alcuni
esempi vivo i me home e jean toni i su
di sì se io sono maestro antonio tu chi
sei vivo soggetto iva
io fino a rodi si sa se mena lui ha
chiesto di me di me se me la iss e mena
e move tipo di a me non ha detto niente
sarebbe letteralmente a me non mi ha
detto niente in italiano comunque non
ripetiamo due volte ameni ma in griko e
il dialetto è una cosa che si usa
comunemente quindi sia chi semina e il
pronome personale di prima persona
dativo complemento di termine forma
forte forma centrata forma tonica mentre
mou è la forma a roma
quindi andiamo a vedere i serena quindi
il seno accettata invece buona forma ad
ora temo lei pe di mu che mi dici figlio
mia
ragazza mia
allora o è questa la forma e critica
l''ha formata una nicchia e mi dici
attenzione a questo bedimo edimo è
sempre la forma in clinica del pronome
personale però qui è usata come
aggettivo possessivo ragazzo mio sarebbe
proprio letteralmente ragazzo dean e
quindi ragazzo nino altro esempio io mo
so molto viola c riempimi il bicchiere
riempie a me o da tener presente che
viene pronunciato raddoppiato line
perché la parole precede è una parola o
si dona cioè centro sull''ultima sillabe
quindi si fa sentire il raddoppiamento
della consonante che segue
altro esempio isee plum né a irina sei
più grande di me
l''iri mena accusativo singolare a firme
stay lasciami stare anche questo me e
questo dà forma ad ala del pronome
personale di prima persona singolare
andiamo al plurale imi e chrome e creati
mali palace
noi non mangiamo carne il venerdì santo
in fa da soggetto e questo noi cini rowe
tisane a zeman
loro hanno chiesto di noi a zeman ma se
di qena sacco sidari
ci ha dato un sacco di grano
posso anche dire ma se di che nas sacco
disse ma ha dato un sacco a noi posso
dire
ma se di che oppure e di che esse ma ma
sforna senso telefono ci ha chiamato al
telefono ma ci tenete ma classicismi
portateci vino e pane per edema a noi
portateci anche qui si pronuncia
raddoppiato perché centro galles e
l''ultima sillaba è la parola che precede
i toys
ma i to his ma qui da noi ma accusa dio
posso anche dire i toso ma brani ma a
nome sta fra noi ci capiamo clima fra
noi forma tonica per cercare in questa
slide e vediamo la seconda persona del
pronome personale in italiano a essere
tu per il singolare voi per il plurale
in griko tu si traduce i su voi i sì poi
le forme del complimento sono a cesena
ditte o più lento di specificazione in
scena a te oppure di termine sena poi
sena complemento oggetto italiano te
per quanto riguarda il plurale quindi
abbiamo i sì quando funge da soggetto
voi nelle forme del complemento abbiamo
accesa
di voi chissà poi se a voi complemento
di termine is a complemento oggetto voi
queste che abbiamo letto sono le forme
toniche cioè le forme accentate del
pronome personale
accanto alle forme toni che abbiamo
anche le forme at one in cliniche o pro
politica e sono super il complemento di
specificazione al singolare su per il
compimento di termine e severi compere
al progetto con l''avvertenza però che il
sud del complemento di specificazione si
usa come aggettivo possessivo quindi
puro mentre su complimento di termine
esse complemento oggetto equivalgono all
italiano di età per quanto riguarda il
plurale abbiamo sa sas sassa sa
corrisponde alla particella pronominale
di complemento di termina cioè a voi e
vi complemento oggetto voi
per quanto riguarda il complemento di
specificazione vale quello che abbiamo
detto per il singolare cioè sa si usa
solo come aggettivo possessivo e
corrisponde all italiano vostro
vediamo adesso le di esempi ipotesi a
miazzo nesta io e te ci assomigliamo
gesù e questo soggetto notte d''arazzo
siro mi souto leo oppure se avessero
allora assuto leo lo dico a te te lo
dico lo dico a te il suo è il
complemento di termina se io invece dico
se al liceo il se e il complemento
oggetto formato ma che è questo
mobili se a cesena mi ha parlato di te
di te è il complemento di specificazione
quindi a cesena di the hills sena e
sapori tipo di azione ma a te non ti
importa niente di me notiamo qui che a
te è ripetuta due volte cosa che in
italiano
non è corretto
a te non ti importa quindi abbiamo la
forma conica il seno del complemento di
termine a te e poi anche la forma a dona
su cortei a sé mena anche questa la
forma
tonica però del pronome di prima persona
quindi il sena
chissà se a te esso cortei quella essa
posto fa dalle prove che il suo che la
forma ad una che risponde alti e te lo
cambiano di sé in cosena non voglio
nessun altra eccetto che telo in questo
caso anche il significato di amare
quindi non amo nessun altro se non te
eccetto de sena e l''accusativo della
forma tonica sena questa qua
vediamo qualche esempio del pronome di
seconda persona plurale i sì del
carroccio stefano ma tu parlino voi
siete andati al matrimonio di paolino
easy nominativo plurale voi illesa
essa si nei titoli azionari
a voi non vi ha detto niente di noi
da notare anche qui la ripetizione a voi
vi si sa è la forma tonica sas la forma
ad ora quindi esse sa e sa a voi non vi
e questo sarà non di ha detto niente di
noi nasa sdo il tocco che vi dia un
accidente sas e la forma avrà l''idea di
a voi vi dia sas sas di ei polli cero
raes astro è molto tempo che non vi vedo
sas
anche questa è la forma ad una sas però
in questo caso e complemento oggi non
vedo noi chi vuoi
sì e ladies e mena poi sa ha salutato me
o voi isa forma accettata del pronome di
seconda persona mentre mena è sempre la
forma cerca davvero del proprio
personale di prima persona le abbiamo
già visto ma tra mar si chiama una
cosetta per noi via ma questa è la forma
conica ed eccoci arrivati al pronome
personale di terza persona che vediamo
raffigurato in questa diapositiva in
italiano e egli per il maschile è l''aver
il femminile al plurale essi s e poi
tutte le varie forme del complemento
quando fa da soggetto abbiamo chino
chini chino cinici nei cina
teniamo presente che il pronome
personale
altro nome che l''aggettivo o pronome
dimostrativo che abbiamo già studiato
nella apposita menziona vediamo quindi
le forme toni che nel singolare che sono
per il soggetto quindi chino chini chino
egli è propriamente cina quindi
significherebbe quello quella quello
però lo possiamo tradurre con il proprio
personale egli è il complemento di
specificazione abbiamo ci nuccini cv
oppure a cecina passeggini avvicino di
lui e di lei complimento di termine
chino cinici ma a lui oa lei e
complemento oggetto chino chini chino
come il soggetto lui lei è chiaro che in
italiano quando il soggetto dovremmo
dire egli ella anche se invalso l''uso di
dire lui e lei lui e lei invece si
dovrebbe usare soltanto al complemento
progetto per quanto riguarda le forme
ato ne abbiamo per il complemento di
specificazione to etiche come abbiamo
già detto corrispondono al oggettivo e
crow nome possessivo poi abbiamo tu e ti
sto per il maschile è neutro tease per
il femminile italiano gli è il
complemento oggetto top team
top flop il maschile è neutro la per i
fermi le facciamo qualche piccolo
esempio o pappo to suo nonno limana di
sua madre la madre di lei
complemento di termine in questo caso
non ha più la funzione di roma come
possessivo alla funzione di promuove
personale to ipa
gli ho detto di sì pa
le ho detto ciò idrica
l''ho trovato in idrica
l''ho trovata femminile se ci ricadiamo
al nome neutro toh idrica passiamo al
plurale quindi il plurale cinici nei
cina che significa essi s
quando fa da soggetto c noci nocino
oppure a cicinho a cecina e cina di loro
di essi ci noci noci no allora cina cine
cima loro complemento oggetto è formato
ne so che per il complemento di
specificazione che fa la cronometro
cessivo loro poi tos per il compimento
di termine loro in italiano tu stessa
età complemento oggetto tossiva ho detto
loro to see brica li ho trovati o cavato
loro tesi brica ho trovato loro più
carino più femminile tra i bric a ho
trovato loro riferiva al nome neutro
vediamo degli esempi chino nube cai sua
for us en al ricci norcia egli mi ha
detto che tu hai comprato una cinghia
nuova tosto chino giorno dai a lui i
soldi
si no
a lui da luca alcini in e catalin mena
posso dire anche tarocca cini passeggini
e accini di lei la forma tonica chino
giovane alla dia quasi presenta a lui
hai messo olio sulla frisella fino a lui
vicini
caio nomina i siti cani con lei
meglio non avere a che fare e ginny cini
complimento il centro accusa di came to
one tra i gridi sgridano sarebbe fai a
lui tu a lui la forma ad ora buona sotto
chiama la buona sotto questo ti chiama
la cina i peti haas strada quelli sono
ragazzi di strada cina e il neutro
plurale essi neuro perché riferivo a
pedia che neopro plurale notte to astori
testo came da bree a me so panieri
quando li vedi di loro che dopodomani
andiamo al mercato tu story tus la forma
a roma quando li vedi quando vedi loro
questo testo di alloro
anche questa è la forma ad ala di loro
complemento di termina a chi allora tesi
bric a praga lotta si napoli sia posso
anche dire idrica cine raga l''onta cena
crisi ha naturalmente test e la forma a
dona cine e la forma tonica o accentrata
quindi test i brigate oppure cina cini e
su dio né mancuso mi lavai essi l''oro a
che possiamo vivere o quelli non ti
danno neanche pane da mangiare
cini nominativo plurale a schive essi
iva o panta messina
io vado sempre con loro attenzione cina
siccome a la finale potrebbe trarci in
inganno e per pensare che ci riferiamo a
un nome femminile quindi tradurre io
vado sempre con lei in realtà cina e
accusativo neutro plurale quindi
dobbiamo tradurre con quelli se vogliamo
dire io vado sempre con lei con quella
devo tradurre macini se poi voglio dire
con quelli riferito al nome maschile di
rom e cino quindi né cina leccino con
quelli vicini
sarebbe questo e cinili femminile a
questo tipo femminile singolare bene con
questo è tutto abbiamo terminato la
lezione
i pronomi personali di prima seconda e
terza persona spero di non essere stato
troppo monotono e seccante e vi do
appuntamento alla prossima versione
ciao a tutti', FALSE),
(15, 'TBmX4e6y9og', 'Pronomi Interrogativi ed Esclamativi', 'pronomi_numerali', 'Pronomi & Numerali', '13:04', 1088, 'Morfologia e sintassi delle particelle interrogative ed esclamative: ''poe'' (chi), ''ti'' (che cosa), ''pion'' (quale), ''pos'' (come) e ''pu'' (dove), con modelli di dialogo quotidiano.', '«Poe spèddhi ''s anemurìa, therìzi anemurìa» — Chi semina vento raccoglie tempesta.', 'benvenuti a questa nuova lezione nella
quale parleremo degli aggettivi e
pronomi interrogativi ed esclamativi
li vediamo qui in questa diapositiva
questo schema sinottico e diciamo subito
che si chiamano interrogativi se si
trovano in una frase interrogativa
esclamativi invece se si trovano in una
frase esclamativa quali sono allora
abbiamo kiss e ti tease che si traduce
chi ti che si traduce che il tis e per
il maschile femminile e neutro e si usa
il riferimento a persona
chi invece è neutro e si riferisce a
cosa cioè quando parliamo di cose
useremo t quando parliamo di persone
useremo chissà diciamo anche che è tease
e soltanto pronome mentre ti può essere
sia pronome sia oggettiva poi vedremo
degli esempi anche oggettivi e pronomi
interrogativi sono ossa o si possa possa
avere il maschile rossi per il femminile
e possa per il neutra che significa
quanto o quanta femminile e play off le
app leo e significa quale da tener
presente che posso rossi posso si
declina come l''aggettivo malo mali ma lo
show è conosciuta in o al maschile in uk
e mini dai no per il neutro al
nominativo singolare ma lo significa
grande mentre play si declina come pac e
opachi a a chievo che significa grosso
cioè come un aggettivo che esce al
nominativo singolare ino ino ino e
adesso vediamo degli s
tempi thyssen e c.so p di chi è quel
ragazzo quindi tease si riferisce al
nome nero ed è nominativo singolare
sisine cine come fonazione chi sono
quelle che mi chiamano qui ti si
riferisce a cineghel femminile plurale
quindi abbiamo usato sempre chi setino
seppe di cino di chi è figlio quello di
chi è un genitivo e che è questo tino se
di get sordo a chi hai dato i soldi
chinos vale anche per il dati voce per
il complemento di termine tino phone a
sé e fauna sa di no
attenzione chi hai chiamato chi no e
l''accusativo singolare c''è la posta con
perché è caduta la n di chi non è fona
sa di no non ho chiamato nessuno
quindi chi non sa se questo di no e
l''accusativo di disse quindi chi hai
chiamato in trentino è invece
l''accusativo dell''aggettivo indefinito
che abbiamo già visto a proposito degli
aggettivi indefiniti chi brama è tua o
muovere e mentre nei primi cinque esempi
e abbiamo visto tease i diversi casi
nominativo gengiva da diva eccetera qui
e cominciamo a vedere e ad analizzare
l''aggettivo o pronome interrogativo
l''esclamativo t
in questo caso di prà ma è tua o
un''opera che cosa è questa che mi hai
portato allora chi brama il ti sta
accanto al nome prama quindi di e
aggettivo aggettiva interrogativo perché
ci troviamo in una frase interrogativa
timo lei sa se calo che mi dici di buono
di in questo caso è pronome perché non
accompagna nessun nome ci troviamo
sempre una frase interrogativa
quindi è un pronome interrogativo chi
dice bonanni che cosa stai facendo
qui invece ci troviamo una frase esclama
viva perché c''è il punto esclamativo ti
non accompagna nel suo nome quindi è un
pronome esclamativo accusativo tst
milone di che cosa parliamo
accedi di che di che cosa posso scorrono
ei quanti anni hai
asus è l''accusativo di posso accusativo
plurale da tener presente che la s
a volte si pronuncia ea volte no quindi
posso dire anche posto crono ei posso
acutezza tutto parlo ci quanto hai
pagato questo orologio posso e pronome
interrogativo
fosse saldo ma degli avi cane quante
settimane sono passate accompagna il non
a domande quindi aggettivo ci troviamo
in una frase interrogativa quindi
aggettivo interrogativo posso pole ma
quanto lavora posso è un pronome perché
non accompagno nessun nome
ci troviamo in una frase esclamativa
quindi pronome esclamativo l''eac annoia
e vale sonante sidero quali cannelli hai
messo nell in canna toyo clea accompagna
il nome con noi ha quindi è un aggettivo
interrogativo perché ci troviamo in una
frase interrogativa le neo madri e vale
sogin urge quale camicia hai messo la
nuova leo amati cleo e aggettivo per che
accompagna il nome ma ti ma di è neutro
cleo è neutro kapok a leo e cannavaro
certamente quale dovevo mettere leo si
trova in una frase esclamativa è un
pronome perché sostituisce il nome ma ti
quindi un pronome esclamativo e adesso
analizziamo i pronomi relativi che
vediamo schematizzati in questa tabella
essi sono a cino cinici non cini cina e
cina o al plurale o indeclinabile vale
per il singolare e per il plurale è la
stessa cosa dicasi per ca
che si traducono in italiano italiano si
traduca il po e il ca con che è il quale
la quale oppure al plurale i quali le
quali vediamo adesso alcuni esempi
tazzari pura forza enisa frisco il pesce
che comprai non era fresco o e questo
quindi possa tradurre che compra e o il
quale conferma in italiano è meglio che
comprai abbiamo comprato i pane cascino
po aveva né it e schiena ma greco na
hanno detto che colui che è morto ieri
aveva una malattia incurabile chino con
colui che a lesa tesale caino sa ho
immaginato le olive che ho raccolto
ecco in questo caso abbiamo usato al
posto di paul però non c''è una regola
fissa si può usare indifferentemente ah
ecco naturalmente che è di origine
latina deriva dal quad il po è di
origine greca e viene usato anche il
greco moderno attualmente cina cucino no
iseo patera i pedi a calle stime one
vanta quelli che coloro che ha
comunicato il prete sono ragazzi che
bestemmiano sempre cina o ecco cina o
cinico lei tutta prama da e nate matara
con lei che dice queste cose è una
bugiarda colei che è cinico cin cin
questa attenzione a questa frase cinico
leone tutta franata in sematary quelli
che dicono queste cose sono bugiardi
notiamo la differenza che c''è tra primo
cini e il secondo cini cini e femminile
singolare perché lei verbo lei significa
dice e singolare quindi cini e femminile
quella che con lei che dice
nella seconda frase invece abbiamo
cinico un leone leone e terza persona
plurale dicono quindi cini e plurale ed
è maschile plurale cini o l''ora
concludiamo questa lezione anche questa
volta come un proverbio tease prodi
esterni prodi sia nonni chi prima semina
prima raccoglie vi saluto e vi do
appuntamento alla prossima lezione che
sarà sui pronomi personali
ciao a tutti', FALSE),
(16, '_nQhT5XUggI', 'Gli Avverbi di Modo, Tempo e Luogo', 'invariabili', 'Parti Invariabili', '23:02', 1733, 'Prima parte dedicata alle parti invariabili: avverbi temporali (''simeri, aurio''), spaziali (''embrò, oppi, addhù'') e modali (''kallio, assama''), con derivazioni dirette dal greco arcaico.', '«Simeri ''s emena, aurio ''s esena» — Oggi tocca a me, domani toccherà a te.', 'cari amici benvenuti e ben trovati a
questa nuova lezione nella quale
parleremo degli avverbi prima di
iniziare mi sembra doveroso fare una
premessa in queste diapositive che
andremo a vedere
troveremo una serie di avverbi con la
loro traduzione a fianco cosa che si può
visionare in qualsiasi vocabolario di
griko cartaceo o online e di questi ce
ne sono tanti tra cui pure di mio che
riporta i vocaboli del greco di
sternatia ma lo scopo delle nostre
lezioni e soprattutto quello di dare la
possibilità di apprendere il griko di
ricominciare a parlare questa lingua che
come abbiamo già detto rischia di
estinguersi
pertanto accanto a ciascun avverbio
riportato in tabella troveremo degli
esempi delle brevi frasi che io vi
consiglio di memorizzare infatti per
poter ricordare un termine bisogna
inserirlo in un contesto in una frase
quando da bambini impariamo a parlare la
lingua che ci viene trasmessa nei nostri
genitori visualizziamo in una situazione
reale gli oggetti che ci circondano ai
quali attribuiamo il nome ma siccome
oggi questo non è possibile in quanto il
grigo non si trasmette più alle nuove
generazioni
cerchiamo di memorizzare almeno delle
semplici frasi e poi costruire
gradualmente delle frasi più complessa
dunque diamo inizio a questa lezione
sugli avverbi e cominciamo da gli
avverbi di modo quelli che vediamo
schematizzati nella tabella sono solo
alcuni infatti molti avverbi derivati da
aggettivi in griko come pure in neogreco
si formano togliendo all''aggettivo la
desinenza del nomina
singolare e aggiungendovi una a allora
come abbiamo detto qui visualizziamo gli
avverbi di modo
incominciamo da anta ma che significa
insieme vediamo una frase fame si poteva
alta ma mou scompaiono
andiamo alla bottega insieme ai compagni
assa via piano pratico passa dias a via
cammina piano piano il salio già lì a
poco a poco il salio celio e casa voluto
il sordo a poco a poco ho perso tutti i
soldi crif di nascosto ci si dio doriot
e crif quei due si vedono di nascosto
fonarà apertamente tempo fornara cinocca
enna movie dimmi apertamente quello che
mi devi dire letteralmente sarebbe
quello che ho da dire a me ho la mia
ad un tratto ho la mia asprezze c''è
fronti se tutto a un tratto lampeggio è
buono cala bene il cus e cala artena hai
sentito bene adesso ashima male a noi io
me
ac ma mi sento male
i tool così
i tool e s''impone a me propria così non
andiamo d''accordo per nulla
cos come o se ne as briscoe mai esso su
come che non ti trovo mai a casa tua in
quest''altra diapositiva analizziamo gli
avverbi di luogo allora i tool significa
qui ferito gria manocchia accesi tari
porta qui tre covoni di grano itu somma
qua vicino tela e tu
insomma vieni qua vicino
ic la reti mosto all ici sei mesi ci
siamo trovati tutti lì in piazza ambro
significa avanti oppure vicino a idrica
nascita ambrosi porta
ho provato un cane davanti alla porta
anti dietro ampi sul cibo che altezza
con ed è dietro al giardino ho piantato
pecorelle gli spedì in nessun luogo
coperte e stufe di dove sei andato da
nessuna parte
in nessun luogo a panu sopra è
innamorata istighi hd many a vaso gli
invitati la fidanzata
stava seduta sul limitare accardo sotto
3m nome a caso cantona mi riscaldo sotto
al camino a messa in mezzo tra gesù e
soddisfati a me salisse ma tu non puoi
stare tra di noi
in mezzo a noi il spokane dappertutto i
viaggi realtà i spokane andava in giro
dappertutto si può anche dire g realtà
può cane senza iss eccesso
lì dentro a casa indica eccesso sono
castelli sono entrato dentro al castello
iuris a esso mo ecco in questo caso esso
significa a casa.it osso qui dentro un
pene del kite osso e nei tipo di mi
sembra che qua dentro
non c''è niente i top in campagna ma ho i
tozzo napole viso vado in campagna a
lavorare letteralmente i tozzo sarebbe
fuori si intende fuori dalle mura della
città quindi fuori ha il significato di
andare in campagna qui vediamo ancora
derby di nuovo macra lontano
all toni per tema grassi in america
antonio è andato lontano in america
cucchia vicino in cina c''è maria inabile
one cucchia stern e larga vincenza e
maria non abitano vicino stanno lontano
vedete che qua c''è anche larga larga
contano i tour ho qui davanti
qui fuori e giga it umbro nadia go aria
sono uscito qui cuori per prendere aria
umbro lì davanti lì fuori su un brocco e
denaro e moro liquori si sente un rumore
vedete che il timbro action brough sono
formati da un proprio i tool e da ambro
più ici sorte a la diritto certe a sole
vito venete cannes o da quella parte
all''oliveto si vede fumo sarebbe lì
diritto all''oliveto oppure da quella
parte
giunti da dietro su un peso tico cribis
aton da bacco là dietro al muro o
nascosto il tabacco o dove fu state
opache riposò dica dove sta il coltello
che ti ho dato attenzione ho accettato e
avverbio il luogo dove questo scopo
invece
e il pronome relativo dove sta il
coltello che ti ho dato il quale ti ho
dato a tutte da dove a poter che de ciso
zeno da dove viene quel forestiero il
cibo lì dove sta su fermo il cibo stay
stai fermo lì dove sei
abbott o di qua a boccea voci e inganni
manco o padreterno di qua e di là non
passa neanche il padreterno
quindi abbiamo avuto di qua a voci viva
poi agra gr significa rasente idee tra
pronta a craa cras ottico andava
camminando rasente al muro e adesso
passiamo a gli avverbi di tempo quindi
abbiamo it e ieri i tè o protesta moneta
povia sono a pantaleo is martignana ieri
o avanti ieri possiamo anche dire siamo
andati a piedi a san pantaleo a
martignano vanta sempre siccardi a
pantasina bastò nel cuore sempre te o ho
sempre tanta sempre arte o artena adesso
artena mi non aspri
adesso aspetta un po nastri e poi una
verde di partita che vedremo in una
lezione successiva rodina
prima il teso gup rovina
sei arrivato tu prima
tunità stanotte unità se doris assino
stanotte e ho vista in sogno arte bravi
stasera arte bravi pro minaccia da te da
stasera mangio pane acqua e sale a the
bourne a stamattina a the bourne haas
cottimo presta i teso porno invece a
scopi motard quindi stamattina mi sono
alzato presto
ieri mattina invece mi sono alzato tardi
quindi qua abbiamo a the bourne ha
inteso porno ieri mattina da tener
presente che la parola porno deriva dal
greco provino poi notiamo in questa
frase che abbiamo due altri avverbi
evidenziati in rosso resta e tarda
abbiamo detto che gli avverbi spesso si
formano togliendo la desinenza del
bambina tivo singolare e aggiungendovi
una ha comunque sto caso qui è infatti
da presto abbiamo presta e da tardi
abbiamo tarda simeri oggi a bree metà
bri domani dopodomani
minti metà bri domani altro fra tre
giorni vediamo una frase simeri o a bree
o metab li ho vinti metà bri i meno
sospiri mi aspetto a casa mia mi fermo a
casa mia
tota allora tota e nick immagine allora
non c''erano macchine
tale o ma tale di nuovo iat arte nata
male perché sei venuto di nuovo si può
anche dire oltre che è nata male anche
pale o mappale allora feto
quest''anno vedo de persi pro
percy zero significa quest''anno vedo
porque te l''anno che viene sarebbe
l''anno venturo persi anno scorso
properzi due anni fa
vediamo una frase con questi avverbi
persi c''è propersi enica mole c''è manco
feto c''è feto port chiede anno scorso e
due anni fa non abbiamo avuto olive e
neanche quest''anno e l''anno venturo
notte hanno molte isee pronto muto lei
quando sei pronto me lo dici bene a
questo punto ci fermiamo
ma abbiamo ancora da analizzare altri a
verdi in particolare di avverbi di
quantità di affermazione o negazione gli
avverbi interrogativi o esclamativi e
questi avverbi li vedremo in una
prossima lezione che sarà quella sulle
congiunzioni ed integrazioni per adesso
vi saluto e vi do appuntamento alla
prossima adesione
ciao a tutti
a te porna stamattina a che torna a
scott
resta inteso porno invece a scopi motard
a indy stamattina mi sono alzato presto
ieri mattina invece mi sono alzato tardi
quindi qui abbiamo a the bourne ha
inteso porno ieri mattina da tener
presente che la parola porno deriva dal
greco provino poi notiamo in questa
frase che abbiamo due altri avverbi
evidenziati in rosso resta e tarda
abbiamo detto che gli avverbi spesso si
formano togliendo la desinenza del
bambin tivo singolare e aggiungendovi
una a come in questo caso qui è infatti
da presto abbiamo presta e da tardi
abbiamo tarda simeri oggi a bree metà
bri domani dopodomani
minti metà bri domani altro fra tre
giorni vediamo una frase simeri o a bree
o metà bri home intime da bree i meno
sospiri mi aspetto a casa mia mi fermo a
casa mia
tota allora tota eni che mag in e allora
non c''erano macchine pale o ma tale di
nuovo la t shirt è nata male perché sei
venuto di nuovo si può anche dire colpe
che mata vale anche pale o mappale feto
quest''anno terzi c''è property
mica male c''è manco feto e ferito
porchet allora vedo quest''anno vedo
de persi properzi feto significa
quest''anno vedo porte de l''anno che
viene sarebbe l''anno venturo persi anno
scorso properzi due anni fa
vediamo una frase con questi avverbi
persi cioè proper si è mica male c''è
manco feto c''è feto porque te l''anno
scorso e due anni fa non abbiamo avuto
olive e neanche quest''anno e l''anno
venturo notte hanno molte isee pronto
muto lei quando sei pronto me lo dici
bene a questo punto ci fermiamo
ma abbiamo ancora da analizzare altri
avervi e in particolare di avverbi di
quantità di affermazione o negazione gli
avverbi interrogativi o esclamativi e
questi avverbi li vedremo in una
prossima lezione che sarà quella sulle
congiunzioni ed interiezioni per adesso
vi saluto e vi do appuntamento alla
prossima adesione
ciao a tutti', FALSE),
(17, 'AeljpaGekrk', 'Altri Avverbi, Interiezioni, Congiunzioni e Preposizioni', 'invariabili', 'Parti Invariabili', '19:54', 1591, 'Completamento delle parti invariabili del discorso: preposizioni semplici e articolate (''se, me, apò''), congiunzioni coordinanti/subordinanti (''ce, ma, ka, an'') ed esclamazioni idiomatiche del Salento.', '«San i mànna e katsìddha» — Tale la madre, tale la capretta (i figli seguono l''esempio dei genitori).', 'cari amici eccoci arrivati a quest''altra
lezione di griko online nella quale
tratteremo anche avverbi che per motivi
di tempo non abbiamo potuto esaminare
nella precedente lezione qui
daremo una sintesi degli avverbi più
comuni come gli avverbi di quantità di
affermazione negazione di tempo bene
incominciamo subito allora vediamo tipo
ti che si traduce niente o qualcosa
vediamo degli esempi in questo esempio
eneko tipo ti non ha sul gioco non ho
niente da darti in questa frase invece è
chi tipo di namo dall hai qualcosa da
darmi vedere che cambia il significato
della frase negativa adc e grado di
niente mentre nella frase positiva ha
delegato di qualcosa
passiamo a play on hop l''on
che significa più s del ibleo non ti ama
più non ti vuole piu sarebbe
letteralmente leo più naturalmente la n
si fa sentire
davanti a bocale ea consonante dolce
come già sappiamo
chiediamo questa frase è né lombari atto
di como è più pesante del mio l''on
e questo più efebo di ideali o ha
mangiato molto non poco quindi al io
poco o di molto questi sono tutti
avverbi di quantità
nastri un po buconi inasprì chi c''era
mi fa male un po la mano
posso haughton tanto sprone caso posso e
sabato cianciato tanto non vado a te
possa e questo cancro white osso o quite
ossona stizzite ogni tanto si arrabbia
posso dire quindi quai dosso o quanto
sforna vediamo che possa che significa
tanto parecchio sono app è da meno i
checa posso in pieno al funerale c''era
parecchia gente tanta gente plana l''io è
proprio di rona lio significa meno
proprio di dipiù tuo sacco vari plona
lio spirito di cossu
questo sacco pesa meno oppure potrei
anche dire di più del tuo vediamo isa
stavamo isa siamo arrivati alla pari isa
isa può significare pari pari che appena
in tempo
mozzoni stavamo isa isa con il pane
siamo arrivati pari pari e cane isa
isana via ido cabona fece appena in
tempo a prendere il treno
adesso vediamo questi archi avverbi che
sono avverbi di affermazione o di
negazione avverbi di tempo allora un che
significa sì per in arti memena sikora
un collega vuoi venire con me a
sternatia sì o no quindi un sì o dei no
un air come c''è pota sì
vengo e quando quindi un è sempre il si
vota quando avverto di tempo gli ati e
nono al chino bus leo perché non capisci
quello che ti dico
chi sa di perché china lidia e cassetto
parroci davvero hai perduto
l''orologio tina lidia qui è sottinteso
il verbo dire lei tina lidia dici la
verità quindi questo è accusativo
dell''articolo tin e l''accusa tivoli a
lidia che significa verità comunque
anche in dialetto quando anche il
dialetto ancora non stava per perdersi
come si sta perdendo oggi molte persone
di anziché dire veramente dicevano la
verità
per esempio la verità io ho fatto questo
anziché dire veramente io ho fatto
questo posi stay fame cava come stai
andiamo bene posso tuo è nativa di
questo non serve no quindi è nave va
en non c''è
no e ge e l''aveva propria ed è sempre
questa legge n
non aveva propria propria significa
affatto del tutto quindi no non serve
proprio non serve affatto non serve del
tutto buttalo e qui vediamo le
interiezioni diamo subito un rapido
sguardo
allora o in meno significa o in meno
oppure meno a me presto dai mara cena
oppure mara cesena mara cecino e
significa peggio per me
mar.ma race man a significa peggio per
me
mara cesena peggio per te
mara cesino peggio per lui e così via
una interruzione nave significa ecco
questa intenzione usato anche il
dialetto na per dire ecco o votiamo
povero me ne sventurato in dialetto si
dice focu meu in alcuni paesi poi voti a
fatiha aiuto aiuto sarebbe letteralmente
fuoco fuoco per dire aiuto aiuto ma car
home beato me oppure maga rosso
beato te magarotto beato lui
eccetera poi il famoso calo sirte che
vediamo nei cartelli di benvenuto nei
nostri paesi della grecìa salentina
quindi calo sirte benvenuto calo sirte
benvenuti poi nata a chi yasi che tu
possa
a moltiplicare x 1000 quindi una formula
di augurio
un augurio natali gas
vediamo subito la tabella di questa
diapositiva quindi abbiamo c''è che si
traduce e crediamo una frase irap e va
c''è i mari a chi ne ha 33 raffaella e
maria sono sorelle the man è una
correlativa negativa etero della fao
dell''avvio non voglio né mangiare né
bere molo tuo con tutto ciò non eco
panta si dimena c''è molo tuo hemecker
età
l''ho sempre aiutato e con tutto ciò non
mi saluta notte quando molte iene se ne
ha il suo ancignano easy quando
diventerai grande tuo comincerai a
capire noi abbiamo la congiunzione car
che detesti casini è fessa di tele che
lei è stupida anna corrisponde all
italiano se a te disi tuo e neto fi
se vuoi questo è il cibo lo fai
sarebbe il mangiare spesso in griko i
sostantivi vengono sostituiti dal mi
fido del verbo tu fai sarebbe il
mangiare tiri caglio senso piri luco
meglio sensi che roba sarebbe
letteralmente meglio cervello che è
ricchezza quindi piri si usa nelle frasi
dove c''è l''idea del paragone caglio
infatti è
comparativa quindi abbiamo tiri che
introduce il secondo termine di paragone
passiamo agli ati che significa perché
gli a timo lei tutta bramata perché mi
dici queste cose sun come bramano
tornava o sa scintille vieri inseguivano
la lepre come cani levrieri sa qui manca
la n c''è l''apostrofa al costo della
inner e che l''orrore che serve comincia
per consonante sorta ma che significa
terra finché è molto usata questa
contraddizione su tuffa nasta di accorto
ti ho detto di stare attento che tu stia
te ti ho detto affinché tu stia attento
qui la u è una crasi cioè la fusione tra
sotto ipa l''audito e la gli di pa che si
fonde e quindi dà origine a o su tuffa
questo fenomeno si chiama crasi naveen
inglesi torrido motte blondie nam in si
può anche dire nein
allora vediamo cosa significa non
toccare il cane quando dorme allora
posso dire na.min inglesi
oppure più semplicemente mini inglesi
oscillo monteroni mi piace youtube un
bene siamo all''ultima congiunzione undo
anzi alla penultima perché poi abbiamo
sappe osapp sia allora mi piace idro con
due bene mi piace così come è
con questo corrisponde a como mili supsi
akano padreterno parla come se fosse il
padreterno quindi sap posso dire sacco
oppure sap si sa è indifferente e adesso
passiamo alle preposizioni sono semplici
e articolate come la rwc ronde in italia
vediamo allora già a parte napa ispra co
meno già da adesso vai stanco sei stanco
by significa probabilmente mai allora a
parte ma e apu solamente che davanti a
parola cominciata per votare si a posto
quindi da acu da già da adesso quasi
thalassa is the rent scegli avendo
martana vado al mare a otranto e passo
da martano quindi qua vediamo si talas
si è caduta la n perché thalassa
incomincia percorso nantes è stato
scritto da posto l''avvenuto francamento
della m quindi partita la cyber ento a
otranto e passa da martano abu da
martano o argalìo e ne gino atti ma lamu
il telaio è quello di mia madre sarebbe
letteralmente della mamma mia a chi è
questo abbiamo detto quando abbiamo
parlato
nell''articolo che a volte anzi spesso in
griko anziché l''articolo kiss che
l''articolo del genitivo femminile
singolare si usa atti e qui abbiamo
proprio questo esempio dove atti
significa della bella mamma mia a fora
sati coupé da chi ha meno celati malamov
ho comprato la coperta per me e per mia
madre è di per sé per la mamma mia per
la d''uso dati li drs crosati questo
anello e d oro a se qui in produce un
complemento di materia e su cortei tipo
di azzaman a non ti importa niente di me
abbiamo sdn clonati lo tiri sena e più
alto di te in questo caso abbiamo tiri
che introduce il secondo termine di
paragone benson a fi
irina millesi pensa a mangiare anziché a
parlare quando tiri e seguito dalla
assume il significato di anziché invece
di il the net o praino portò meno accesa
kukri dario è giunto con il carro carico
di sacchi
di orzo anziché dire il pm top praino
posso anche dire il tema traino essendo
praino un nome maschile
vediamo che qui è caduta la n e stata
messa l''apostrofo del francamente lo
stesso avviene qui dovrebbe essere mon
però siccome fra i know incomincio del
consonante per ti cade la n si lettera
vostro fa allora il mon
e il match non è questo metodo non ho la
tappezzeria in a panahi se meno tutti i
pensieri sono su di me tutti i
grattacapi sarebbe sono su di me a paris
e con aprono a mesa soggetto o un dolore
in mezzo al petto fra il petto sarebbe
ammessa solo bene siamo arrivati alla
fine di questa lezione e anche questa
volta concludiamo con un proverbio i
cibus un pezzo su un pay puro lizza reda
traduzione lì dove salta la capra salta
pure la capretta il proverbio vuol dire
che i figli seguono l''esempio dei
genitori sia nel bene sia nel male vi
saluto e vi do appuntamento alla
prossima lezione
ciao ciao', FALSE),
(18, 'FT0UHEjkuh4', 'Il Verbo Griko: Introduzione e Aspetto', 'verbi', 'Sistema Verbale', '21:06', 2012, 'Inizio del grande ciclo sul verbo griko. Spiegazione dell''assenza dell''infinito (sostituito dalla subordinata con ''ka/na''), della distinzione d''aspetto tra azione continua e puntuale, e dei modi finiti.', '«To stefànoma eni gliki, ma ''i zoi eni pikrì» — Il matrimonio è dolce, ma la vita impone sacrifici.', 'cari amici benvenuti a questa nuova
lezione
siamo giunti a parlare del verbo greco
che è un argomento che richiederà
diverse lesioni in quanto abbastanza
complesso comunque cercheremo di
sintetizzare e di trattare i punti
focali che permettono di capire il
meccanismo della formazione dei tempi
nella lingua grika e cercheremo di
essere quanto più possibile chiari ed
esaurienti
in questa lezione tra l''altro punteremo
lo sguardo soprattutto sulla forma sul
genere sulla radice o tema del verbo
comunque andiamo per ordine
in questa slide analizzeremo la forma
del verbo la forma del verbo può essere
attiva medio passiva passiva
diciamo che la forma del verbo è attiva
quando il soggetto compie l''azione la
forma medio passiva corrisponde alla
forma riflessiva italiana la forma
passiva invece si sa quando il soggetto
subisce l''azione
vediamo le desinenze della forma attiva
spieghiamo innanzitutto anzi ripetiamo
che cos''è una desinenza la residenza
della parte mobile del verbo e abbiamo
già parlato a proposito del nome e della
gestivo desinenza e la parte mobile che
determina la persona e il numero del
verbo allora quanto riguarda la forma
attiva
abbiamo la desinenza o per esempio
prendiamo in esame
per bondi no io vesto vederla radice o
tema engine la desinenza o io resto io
il soggetto io con l''azione del vestire
quindi a forma e attiva
per la propria media passiva la
desinenza e come di nome io mi vesto la
forma medio passiva abbiamo detto
corrisponde alla forma riflessiva
italiana a volte anche alla forma attiva
per alcuni verbi quindi la struttura e
passiva la desinenza è quella del
passivo però il significato è riflessivo
o attivo passiamo alla forma passiva la
forma passiva si ottiene aggiungendo il
verbo essere che indico è il verbo linee
al participio passato del verbo per
esempio e dire che io vengo vestito da
un altro di rho vivo im e di meno oppure
meglio ancora ercom andy meno io vengo
vestiva sedico ivo imen di meno
significa che io sono nella situazione
di essere gestito cioè di essere già
vestito ritrovo vestito per dare l''idea
che il soggetto io subisce l''azione
sarebbe meglio dire ercom andy meno cioè
vengo vestito da un altro
comunque la forma passiva in frigo e
poco usata generalmente si preferisce
volgere all''attivo la frase anziché dire
io vendo vestito dalla mamma si
preferisce dire la mamma veste è tornata
un attimo al discorso della forma medio
passiva dobbiamo dire che quasi tutti i
verbi in griko possono avere sia la
forma attiva sia la forma medie passiva
comunque ci sono alcuni verbi che
vediamo qui in nota come fe no me io
sempre
per come io vengo ye nome di vento forio
ho paura
il cui significato rimane sempre attivo
cioè hanno la forma del passivo la
desinenza del passivo però non hanno né
significato passivo nel significato
riflessivo ma hanno soltanto significato
attivo
passiamo ora alla diapositiva successiva
e qui parleremo del genere del verbo
allora i verbi possono essere transitivi
e intransitivi si dice che è un verbo e
canti divo quando l''azione compiuta dal
soggetto transita direttamente su un
complemento oggetto che riceve questa
azione intransitivi invece quando questo
non avviene quando non ci può essere un
complemento oggetto
facciamo qualche esempio se io dico la
mamma prepara la tavola
la mamma il soggetto l''azione è quella
del preparare quindi il verbo è prepara
che cosa la tavola quindi abbiamo il
componente oggetto quindi il verbo si
dice transitivo se io invece dico la
mamma si siede a tavola in questo caso a
tavola non è un complimento oggetto né
tantomeno ci potrà essere perché il
verbo sedersi non prevede un complemento
che risponda alla domanda chi che cosa
alcuni verbi comunque possono essere
usati in griko transitiva mente o
intransitiva mente come ad esempio i
verbi intransitivi meno aspetto feo che
significa corro tolgo io rizzo che può
significare sia attorno sia restituisco
comunque vediamo degli esempi oscar
paris ti alzi te scarpe il calzolaio
aggiusta le scarpe vediamo che per
bastian sì quindi e transitivo in quanto
c''è il complemento oggetto le scarpe che
cosa giusta le scarpe i maria perche
attinà crisi a maria viene dalla chiesa
perché ne è un verbo intransitivo in
quanto non può avere non ha e non può
avere un complemento oggetto non posso
dire maria viene che cosa meno soccorra
ti napoli miso ecco in questo caso il
verbo meno è uno di quei verbi che può
essere usato sia transitiva mente sia
intransitiva mente in questo caso è
usare il senso intransitivo meno so
corati mi fermo in campagna per lavorare
di fermo quindi intransitiva se meno si
mesina chiacchiari showman aspri
ti aspetto in piazza per chiacchierare
un po quindi in questo caso meno è usato
in forma transitiva in quanto c''è il
complemento oggetto se aspetto te ti
aspetto toppeta g6 si scola il vero che
ho qui è usato in senso intransitivo il
bambino corre a scuola
fiat ha materia atti banca in questo
caso invece che usato in senso
transitivo perché ci compro nel progetto
tra materia
togli i coltelli dal tavolo con toni you
rizzi metà bri mappatura antonio torna
dopo domani col treno più rizzi verbo
iorizzo qua è usato in senso
intransitivo torna non posso dire torna
che cosa in questo caso naziste no la
moioli cicinho co sudan isa ricorda di
di ritornare a me di riportarmi quello
che ti ho prestato di ritornarvi che
cosa quello quindi c''è il complemento
oggetto quello è usato in senso
transitivo bene e adesso osserviamo
attentamente questa positiva che è una
diapositiva importante per capire la
formazione dei tempi nella coniugazione
dei verbi grigi allora noi dobbiamo
tener presente che alcuni tempi si
formano dal tema del presente
altri dal tema del lavori st.pauli sco
ha detto per inciso corrisponde al
nostro passato remoto
si chiama auris e significa indefinito è
formato da al privativo estetica senza e
dal verbo greco o rizzo che significa
delimitare noi abbiamo in italiano il
termine orizzonte che deriva da o rizzo
l''orizzonte è quella linea che non ci
permette di vedere oltre
quindi a cristo significa
senza limite è chiamato così perché
spesso in griko si usa lavorista senza
fare distinzione tra il passato recente
e il passato remoto cioè tra il passato
prossimo e il passato remoto si usa
l''aoristo indipendentemente se l''azione
è avvenuta in un passato recente o in un
passato remoto in italiano pertanto l''ha
visto si può tradurre sia col passato
remoto che col passato prossimo
naturalmente dobbiamo dire che cos''è il
tema di un verbo il tema come vediamo
dagli esempi qui riportati
e la parte fissa a parte che non cambia
momento la desinenza come abbiamo già
detto in precedenza e la parte mobile
quindi alcuni tempi in griko si formano
dal tema del presente perché vado il
presente in questo caso stiamo
analizzando il verbo danny significa
legare io leggo la radice eden
quindi abbiamo per la forma attiva e per
la forma medio passiva sempre la radice
o tema chiamatela come volete
then ben invece alcuni tempi si formano
dal tema dei lauri store
allora qui vediamo innanzitutto ed esa
per che cosa è formato e de sac
questo aveva formativa è formato dal dal
tema di a cui però viene aggiunta una s
quindi il tema ed es
poi c''è la desinenza a e poi c''è questa
è che l''aumento di cui parleremo in
seguito ed esa e formato dall''aumento e
dal tema des cioè tema del presente più
la s quindi in questo modo si forma il
tema dell''ariston
e poi la che è la desinenza questa bella
forma attiva per la forma medio passiva
abbiamo test quindi si aggiunge una s è
una t in alcuni casi in altri casi
invece per archi verdi solamente una t
come potete notare manca l''aumento
aumento ci dovrebbe essere ma in griko
spesso anzi quasi sempre non si fa
sentire
quindi destino pd dest e il tema del
risto la forma medio passiva oppure
anche ci può essere
l''aggiunta di una sola senza la s come
nel caso del verbo di no che abbiamo
visto nella slide precedente che fa di
timo
io mi vestii io mi sono vestito nelle
prossime diapositive
vedremo quali sono i tempi che si
formano dal tema del presente e quali
invece quelli dal tema dell''ariston e in
questo schema
vediamo quali sono i tempi che si
formano dal tema del presente del verbo
de no io leggo
allora abbiamo il presente attivo denno
io leggo il presente medio passivo del
nome io mi lego
ricordo ancora che la forma medio
passiva ha il significato del riflessivo
e in alcuni casi come per esempio il
verbo air come o forio me che abbiamo
già visto addirittura significato attivo
ma abbiamo il participio presente denota
e significa legando con valore temporale
cioè mentre leggo o mentre legavo poi
l''imperfetto
attivo ed enna io legavo vediamo che qui
e l''imperfetto e proviamo
l''aumento è il perfetto medio passivo
della mot
io mi legava qui invece vediamo i tempi
che si formano dal tema dell''ariston
attivo allora abbiamo la ho visto ed esa
io legai il futuro
enna des eaux io legherò l''imperativo
des è legato il participio aoristò
desunta legando legando però ha un
valore ipotetico se io avessi legato per
esempio jason tatto da mali eni che
scappa zonta se avessi legato il bue non
sarebbe scappato
e poi abbiamo l''infinito daisy le gare
ricordo che l''infinito in griko si usa
solo dopo il verbo sorso per esempio è
sotto tesi non posso le gare e qui di
seguito vediamo i tempi che si formano
dal tema della wsr risto passivo
prendendo sempre in esame per bondeno
allora abbiamo visto destino
io mi lega e futuro e na destò mi
legherò imperativo destro legati to
participio risto desk tonta legandomi è
che questo con valore ipotetico infinito
destino le gare allora dobbiamo
sottolineare il fatto che per quanto
riguarda il futuro in griko non esiste
il futuro vero e proprio ma si ricorre a
questa perifrasi
per dire mi legherò en othe stop che
sarebbe propriamente mi devo le gare poi
per quanto riguarda il participio visto
anche questo abbiamo detto ha valore
ipotetico facciamo un esempio di spunta
di scarpa artena ip è l''offerta se ti
fossi legata alla scarpa adesso
camminare sti più velocemente
un altro punto molto importante per
capire il meccanismo della formazione
dei verbi in griko e quello dell''aumento
del verbo che consiste come abbiamo già
rilevato in precedenza e l''aggiunta di
una vocale iniziale questo aumento
tuttavia non sia sempre per tutti i
verdi osserviamo attentamente la slide
quindi se il verbo inizia per consonante
noi abbiamo l''aumento in però alcuni
verbi per esempio cotto io taglio fa è
cotta all''imperfetto alcuni verbi non
hanno aumento filo inizia per consonante
significa io ma cio si liga io baciavo
quindi come vedete non c''è aumento
alcuni verbi inizianti per consonante
anno l''aumento in per esempio sir no
significa tirare i serna io tiravo
all''imperfetto se il verbo iniziale
locale non abbiamo nessun aumento
esempio a fino fa africa a fino lascio
africa
io lasciai in queste due diapositive che
seguono possiamo vedere nella prima
alcuni esempi di verbi cominciati per
consonante che hanno l''aumento in sé
oppure non hanno nessun aumento in
questa seconda diapositiva invece
vediamo verbi cominciati per consonante
piano l''aumento in i have begun izano
per vocale che non presentano nessun
aumento
questi non mi soffermo a leggerli tutti
uno per uno anche per mancanza di tempo
che potrebbe fare benissimo voi fermando
il video
bene con questo è tutto
chiudiamo qui questa lezione e anche
questa volta con un proverbio arma stimo
navaho scudettata virta madrice anga
dada mi sono sposata e stare tranquilla
invece mi son trovata nera e sporca
questo proverbio allude al fatto che
dopo il matrimonio nascono i problemi
bene vi saluto e vi do appuntamento alla
prossima elezione
ciao a tutti', FALSE),
(19, 'Hq86yBr9T1Y', 'I Verbi Ausiliari: Essere (Ìme) e Avere (Echo)', 'verbi', 'Sistema Verbale', '15:55', 1448, 'Coniugazione completa dei due cardini del sistema verbale: ''ìme'' (essere) ed ''echo'' (avere) nel presente, imperfetto e futuro perifrastico, con i loro ruoli predicativi e composti.', '«Echo kardìa ka ''en echi timì» — Il cuore sincero non ha prezzo che lo possa comprare.', 'cari amici benvenuti a questa nuova
lezione nella quale parleremo degli
ausiliari essere e avere in cominciamo
subito col verbo avere vediamo in questa
diapositiva due tabelle relative al
l''indicativo e al congiuntivo
vediamo un po come funziona qui nella
tabella dell''indicativo abbiamo una
colonna con le tre persone singolari
delle tre persone plurali ivo is uncino
per il maschile cini perché mi vaccino
per il neutro al plurale i mii si finì
per il maschile cina per il 2005 sono i
pronomi personali che noi abbiamo già
visto in apposita sezione
poi abbiamo qui i tempi più indicativo
hai il tempo presente
l''imperfetto che uguale al risto il
perfetto che è un tempo composto e
corrisponde al posto del prossimo
italiano è il più che perfetto anch''esso
un tempo composto che corrisponde al tra
passato prossimo o trapassato remoto
italiano
quindi vediamo il presente ivo eco io e
chi ci nocini chino e chi i miei e come
noi abbiamo i sì e chiede cinici nei
cina e con il perfetto tipo ica io avevo
oppure io ebbi il suo vice cinofili
chino ice imi chicca ma noi avevamo o
avemmo easy icato
cini cina e cina icahn e il perfetto
vivo e ho avuta e formato quindi abbiamo
detto che un tempo composto ed è formato
da al presente è più il participio
passato avuta che un italianismo che
secondo me sarebbe meglio evitare
sarebbe meglio ricorrere al laurito e
dire ica anziché dire ivo eco avuta
meglio dire ivo ica poi gesù è vicino e
chi i b e come i sì e chiede cini e con
sé più che perfetto pica e conta io
abbia avuto oppure io avevo avuto poi i
sui che è contro chino cini chino ice e
conta chi mitica mo e conta gli si i
cadeaux e conta e cini i cani e conta e
conta è il participio e del verbo avere
e passiamo al congiuntivo
qui abbiamo il presente
l''imperfetto è il più che perfetto
presente in perfetto che corrispondono
ai relativi tempi italiani più che
perfetto che corrisponde al congiuntivo
ha trapassato italiano e diamo il
presente il presente
vedete la colorazione arancione sta a
significare che il presente congiuntivo
ha lo stesso tema del presente
indicativo e si forma
premettendo la congiunzione na che ha un
valore prettamente finale naco l''unione
della colla e diego ha determinato la
caduta della e questo fenomeno si chiama
aferesi
quindi il presente indicativo è di
monaco e sun a chi chino
nati e mina come i sindaci di marcon e
che io abbia che tu abbia che gli abbia
eccetera è perfetto e dede colorazione
verde lo stesso tema dell''ariston quindi
naica che io avessi narice nike nike amo
laicato una chicca né il più che
perfetto naica e conta che io avessi
avuto naica e contra raisi e conta un
alice e conta nike amo e conta naica top
e conta a icahn e e conta in questa
destra diapositiva vediamo il
condizionale per il 4 riguarda il
condizionale si usa l''imperfetto
indicativo dal ca parte anche in
italiano in maniera non proprio
ortodossa spesso si usa l''imperfetto in
negativo al posto del condizionale
infatti spesso sentiamo dire io
preferivo questa cosa anziché dire io
preferirei questa cosa imperativo e
nasce la seconda persona singolare
nascite seconda persona plurale abito
abbiate voi il participio presente è
pronta participio passato avuta
abbiamo detto che questo è un
italianismo da evitare possibilmente per
quanto riguarda l''infinito infinito e e
chi per all infinito si usa soltanto
come abbiamo già detto in altre
occasioni
dopo il verbo socio che significa poter
quindi io posso avere ivo socio e chi
solo in questo caso si usa l''infinito e
adesso vediamo degli esempi e ne hackett
e tipo di acam e dei simeri
non avete niente da fare oggi
hackett e quindi è presente indicativo
seconda persona plurale avete it e
portano frazone somenica sordo
ieri sono andato o andare a comprare
pane e non avevo soldi e nica in
perfetto indicativo eneko acuta tipo di
attivismo non ho avuto niente dalla mia
vita eco avuta quindi perfetto
corrisponde abbiamo detto al passato
prossimo italiano e nica tipo di atti
giaimo usare il passato remoto cioè
maurice in griko il teppista si scola ma
gli attesi mere ica e con l''air masi cei
camino pranzo grati
ieri andai a scuola ma per tre giorni
avevo avuto la febbre ed ero rimasto a
letto quindi avevo avuto più che
perfetto tra passato prossimo
chicca è colpa magari nike amo avuta cit
in occasione magari avessimo avuto
quell''occasione oppure se tolgo avuta
possiamo dire magari avessimo
quell''occasione animano prussia chicca
puro o mia masseria se fossi ricco
avrei anche io una masseria chicca avrei
vedete in italiano lo rendiamo col
condizionare vero ica e l''imperfetto
indicativo chi vuoi
vicino ice e così via
nasci stand carli è la gamma mezzo mi
ricordati che domani dobbiamo fare pane
ma chi sarebbe letteralmente harbie a
mente tieni a mente è l''imperativo del
verbo avere nati e contati immagina di
chisso è stata il doppio i legami nudo
avendo la tua macchina arriverei a lecce
in dieci minuti e conta è il partito
presente però anche qui a valore
ipotetico se avessi la tua macchina
l''infinito abbiamo detto si usa il verbo
sotto e quindi esso 10 nella scritta
scientia non puoi avere un po di
pazienza e quindi qui vediamo gli altri
tempi e modi del verbo in e allora il
congiuntivo
abbiamo le stesse forme dell''indicativo
precedute dalla congiunzione di naim e
che io sia maimone che io fossi la
install meno che io sia stato naim
onestà meno che io fossi stato per
quanto riguarda il condizionale si
ricorre anche qui all''imperfetto
indicativo che l''imperativo presente
abbiamo una isee sito isee st
siate voi per il participio e si ricorre
alle corde del verbo stare che in griko
si dice teo quindi il presente
stenta stando stato ntà stando però con
valore ipotetico e participio passato
sta meno stato per quanto riguarda
l''infinito
finora presente è bene ma si usa anche
sorgesse sorgesse deriva dall''antico
verbo classico oggi est in quindi è una
forma arcaica la forma antica che è
rimasta nel nostro hub l''iva vediamo
alcuni esempi in su teli naim e timo
propri no tu vuoi che sia il primo
quindi na kim è che io sia la seconda
frase è volta al passato e la stessa
frase di prima però volta al passato il
kit elena imone tv o provino tu volevi
che io fossi io il primo quindi che io
sia che io fossi a limone sta meno
sironi icato risulta toccava se fossi
stato a roma avrei visto il papa allora
vedere che questa non è congiunzione na
ma è anna tra congiunzione anna che
corrisponde all italiano se quindi come
in italiano la congiunzione se rende
ipotetico il verbo così avviene pure in
grigo quindi timone e la forma
dell''imperfetto indicativo però
corrisponde anche all''imperfetto
congiuntivo quindi in italiano possa
tradurre se fossi stato a roma
eccetera anche qui vediamo la
congiunzione han han i casi rocca sotto
calcio altra immuno proprio se avessi
vinto al totocalcio
adesso sarei ricco kimono come
evidenziato in nero
l''imperfetto che si può tradurre con il
condizionale
quindi il condizionale corrisponde
abbiamo detto l''imperfetto indicativo
sarei ricco nice st corti molte gratuite
state attenti quando camminate che siate
attenti quindi nyse e sta che siate che
voi siate imperativo seconda persona
plurale stentata prama da ido sekyere e
do stando così le cose ti saluto
stenta participio presente stato conta
essa su eni che è gratuita
rimanendo a casa non ti saresti bagnato
stato conta e parteciperà risto e ha
valore ipotetico quindi se fossi rimasto
a casa non ti saresti bagnato innesto a
meno solo scarpari sono stato dal
calzolaio sto almeno è il participio
passato o participio perfetto apro una
piccola parentesi per dire che sta meno
participio passato in genere è chiamato
anche aggettivo verbale perché si
comporta come un aggettivo infatti sta
meno se si riferisce al 9 maschile st
meghni se si riferisce a femminile e sta
almeno se si riferisce al neutro
leggiamo l''ultima frase so geste caen e
ito e possibile che sia così può essere
sarebbe letteralmente che è così quindi
sorgesse deriva dall''antico verbo soci
est in e significa può essere bene con
questo abbiamo finito
chiudo e vi do appuntamento alla
prossima lezione
speriamo che questa attenzione sia stata
di vostro gradimento
e continueremo nelle prossime elezioni a
trattare i derby appartenenti alla prima
e alla seconda coniugazione di saluto
ciao ciao', FALSE),
(20, 'Yn3TuShAGEs', 'Prima e Seconda Coniugazione Attiva', 'verbi', 'Sistema Verbale', '17:08', 1657, 'Paradigmi regolari della 1ª coniugazione baritona (''pèfto'' mandare, ''kùo'' udire) e della 2ª coniugazione contratta in -ò/-ào (''agapò'' amare). Studio del presente e dell''imperfetto indicativo.', '«Agàpa cini pu se agapùne» — Ama coloro che ti amano con cuore schietto.', 'cari amici ben ritrovati in questa nuova
lezione sul verbo nella quale prenderemo
in considerazione le due coniugazioni
dei verbi regolari di avervi irregolari
parleremo successivamente bene come
vediamo da questa slide le coniugazioni
del verbo grifo sono due prima e seconda
della prima coniugazione fanno parte
quei verbi che hanno l''accento sulla
penultima sillaba cioè sono parsi doni e
hanno la prima persona singolare del
presente indicativo in o sedi formativa
in o mese di forma meglio passiva come
per esempio il verbo denno che ha la
seguente coniugazione la prima persona
singolare i no la seconda sini e la
terza in iper la forma attiva
quindi fa il modello i solenni chino
danny io leggo colleghi e gli lega per
la forma medio passiva le desinenze sono
come ese e the queen di tipo del nome di
su dennis chino venete io mi lego tu ti
leghi egli si lega
ricordo che la forma mag passiva grika
corrisponde alla forma riflessiva
italiana alla seconda coniugazione
appartengono a due tipologie di verbi
sono verbi rossi doni cioè con l''accento
sull''ultima sillaba che hanno la
desinenza in o nella forma attiva e in
yemen nella forma medio passiva come per
esempio il verbo a capo che fa vivo haga
poi su haga pacino a gava io amo tu ami
egli ama nella forma medio passiva alle
residenze sono io
io se siete a ivo a capirne i su haga ds
fino a capire io mi chiamo tutti anni
egli
si sa l''altra tipologia di verbi e
quella dei verbi che hanno l''accento
sull''ultima sillaba e hanno la desinenza
in o sedi formativa inya mese di forma
passiva
però rispetto alla prima classe la prima
categoria diverbi notiamo delle
differenze nelle tre persone singolari
del presente in negativo infatti mentre
haga pof ivo haga poi su haga pacino a
capa il verbo toro fa i voto rho i
sudori chino attori nelle forme medio
passive invece abbiamo sempre le stesse
desinenze io lei sa se siete ora
cominciamo ad osservare la presente da
bella e qui coniughiamo i vari tempi e
modi del verbo ad enna che significa io
leggo
notiamo subito delle differenze tra come
viene coniugato un verbo italiano è un
verbo greco nella coniugazione italiana
si indicano in successione tutti i tempi
di ciascun modo per esempio
dell''indicativo si indica il presente il
perfetto il passato remoto e così via
così pure del congiuntivo presente e
passato imperfetto passato nella
coniugazione greca invece si indicano
tutti i modi di ciascun tempo quindi per
coniugare un verbo agricola
bisogna conoscere il tema del presente
il tema del laurito e il participio
passato dal tema del presente del verbo
ha detto che eden si forma il presente
indicativo dello io leggo l''imperfetto
indicativo ed enna io legavo il
participio presente del 90
legando nemmeno si comporta come un
aggettivo vero e proprio tanto è vero
che è chiamato dai drammatici anche
aggettivo verbale infatti a una
desinenza per il maschile singolare
nile è neutro una per il maschile
plurale femminile è neutro il perfetto
si forma con il verbo avere eco più una
forma a verdiane del participio passato
che ed è meno quindi e code mena o
legato dal tema dell''auris che ed essa
si forma lauri spa ed esa
io legali il futuro è adesso io legherò
potevo le gare congiuntivo auris toe che
io le gi oh che io legasse il
congiuntivo più che perfetto che io
abbia legato o che io avessi legato
l''imperativo risco dese de sete legato
legate voi il participio resto de son
tra legando infinito aristo daisy le
gare e adesso facciamo alcune
osservazioni
per quanto riguarda il presente del
diciamo che danno produce sia il
presente indicativo sia il futuro
infatti se in griko devo dire domani o
domani legherò posso dire
ivo avri denno oppure ivo a bree en
adeso si usa questa forma perifrastica
inatteso per esprimere un''azione che
deve ancora avvenire forma perifrastica
significa che faccio uso di più parole
per indicare il futuro infatti
l''espressione enna teso e formata dal
verbo essere che in griko si dice e ne
troncato in con l''apostrofo più la
congiunzione finale ma letteralmente
significa e dalle gare per quanto
riguarda l''imperfetto in negativo
diciamo che in perfetto indicativo
oltre all''imperfetto indicativa italiano
io legavo anche il condizionale presente
io legherei e anche il congiuntivo
imperfetto italiano preceduto però dalla
congiunzione en quindi en eden
se io legacy per quanto riguarda il
capitolo recente abbiamo detto
corrisponde al gerundio italiano quindi
legando del participio passato abbiamo
detto che è un aggettivo verbale quindi
un aggettivo tre uscite il perfetto
indicativo traduce oltre al passato
prossimo
anche il congiuntivo passato quindi
significa ho legato ma anche che abbia
legato
passiamo ora al risto ed esa si porta
guerra sia col passato remoto italiano
sia col passato prossimo infatti lavori
sono significa a tempo indefinito e
indica un azione avvenuta in un passato
recente
oppure in un passato remoto
il futuro è l''atteso significa
propriamente devo le gare quindi dà
l''idea di un''azione che deve ancora
avvenire
come abbiamo detto in precedenza per il
futuro si può usare anche il presente
indicativo congiuntivo ha visto il
congiuntivo rischio è proceduto sempre
dalla congiunzione na che ha un valore
finale inatteso che io le gi oh che io
legacy
infatti se io dico che lo adeso the
scarpe italiano tradurrò voglio legare
le scarpe però voglio legare è una forma
implicita si trasformo in forma
esplicita di rho voglio che io leghi al
sato volevo le gare volevo che l''io
legacy quindi adeso corrisponde al
congiuntivo presente è congiuntivo
imperfetto italiane passiamo al
congiuntivo più che perfetto ica desunta
il congiuntivo più che perfetto traduce
sia il congiuntivo trapassato italiano
preceduto dalle congiunzioni in one sia
il condizionale passato a nick adeso
alta se avessi legato oppure che io
abbia legato interattivo ha visto
delegato mese delegate voi il participio
ha visto desunta a come abbiamo già
detto per gli ausiliari essere avere un
valore ipotetico imperativo ha visto e
daisy ed è preceduto sempre dal verbo
sotto sotto daisy posso negare e adesso
qui vediamo alcuni esempi a brienno all
ataf ortì a domani leggo tutte le
fascine posso anche dire a bree en adeso
cioè posso usare per un''azione che
avverrà nel futuro sia il presente
indicativo dello sia la forma
perifrastica del futuro in adeso formata
come abbiamo detto dal verbo essere più
la congiunzione con valore finale nei
toni da ca eden di scala sopportar i
nani pesi lo vidi che legava la scala
all albero di olivo per non cadere
eden è imperfetto e indicativo e
l''abbiamo tradotto in italiano
in questo caso con
l''imperfetto indicativo aned e ne calati
scala e canne calabra ma se legacy bene
la scala faresti una cosa buona
eden come forma e l''imperfetto però
abbiamo tradotto in italiano con
l''imperfetto congiuntivo se legasse in
questo caso invece e canne abbiamo
tradotto con il condizionale presente
faresti anche cannes e imperfetto del
verbo che hanno quindi come possiamo
vedere nella frase precedente
l''imperfetto lo abbiamo prodotto con
l''imperfetto indicativo italiano nella
seconda frase con il congiuntivo
imperfetto e con il condizionale
presente e non tata vidi i detta crani
spa meno legando il bue vide la fune
spezzata denota abbiamo tradotto con il
gerundio a valore temporale mentre
legava il bue
oppure più semplicemente legando il bue
vide eccetera
mistero carichi di mena all ata
manocchia penso che allegato tutti i
covoni in italiano possiamo anche dire
penso che abbia legato tutti i coloni
quindi il perfetto è indicativo si può
arrendere sia con il passato prossimo
italiano sia con il congiuntivo passato
abbia legato i te io ti pressa e ne de
sade scarpe
ieri
per la fretta non ho legato le scarpe ed
esa e la forma del lavori spa possiamo
tradurre in italiano sia col passato
prossimo
se l''azione è avvenuta da poco oppure
col passato remoto se l''azione è lontana
nel tempo il griko usa spesso lauri
store sia per il passato recente come
abbiamo già detto altre volte sia per il
passato remoto tele ten ad esse datam
paris praino volete legare il cavallo al
carro la de sete e la forma del
congiuntivo aoristò preceduto dalla
congiunzione narchia valore finale in
forma esplicita sarebbe volete che vuoi
legate il cavallo al carro in forma
implicita volete legare il cavallo al
carro amiche desunta calati scala eni
che presenta se avesse legato bene la
scala non sarebbe caduto allora chi è
pesante e il più che perfetto
congiuntivo anche qui i che peso
e più che perfetto congiuntivo vediamo
come abbiamo tradotto se avesse legato
abbiamo usato il congiuntivo travasato
in italiano
bene la scala non sarebbe caduto abbiamo
usato il condizionale passato al posto
di chiede se possiamo in griko usare più
semplicemente il participio aoristò e
dire soltanto desunta calati scala eni
che presenta legando bene la scala non
sarebbe caduto abbiamo già detto altre
volte che il participio aristo a valore
ipotetico
come in questo caso desunta significa se
avesse legato de seta uccio rutelli o
padrona è un modo di dire lega l''asino
dove vuole il padrone dese e la forma
dell''imperativo auris e po di pace o
ethos obesi e molto grosso
non lo posso le gare jesi e l''infinito
ha visto preceduto dal verbo sorso come
abbiamo avuto modo di dire altre volte
l''infinito in griko si usa soltanto dove
il verbo sorso loro verbo poter bene
siamo giunti alla fine di questa lezione
e concludiamo anche questa volta con un
espressione letteraria popolare che è
divenuta proverbiale it e lana su poche
ma basta lapajne ap di manas una sar
masi sin dei manic orasi si tratta di un
verso di una canzone che ha assunto
valore proverbiale perché consiglio le
ragazze a sposarsi finché sono giovani
ciao a tutti', FALSE),
(21, 'vmIJbyURFWE', 'La Forma Medio-Passiva del Verbo', 'verbi', 'Sistema Verbale', '19:17', 1895, 'Analisi approfondita della flessione medio-passiva (''-ome / -ume''), eredità antichissima del greco classico preservata inalterata nel Salento per esprimere la voce riflessiva e deponente.', '«O kosmo yirizi san i spira» — Il mondo gira come una ruota che non si arresta mai.', 'cominciamo subito questa lezione
analizzando la forma medio passiva del
verbo del no io leggo di cui abbiamo
visto la coniugazione attiva nella
precedente lezione dal titolo il verbo
parte seconda ricordo brevemente che il
verbo denno appartiene alla prima
coniugazione in quanto alle prime tre
persone singolari del presente
indicativo attivo in o i e iii cioè fa
vivo dello i suddetti chino danny mentre
la forma nei grassi va alla desinenza
delle prime tre persone in home sé e sé
ed è quindi fa vivo del nome di su
dennis chino venete ricordo che la forma
medio passiva si traduce in italiano con
la forma riflessiva in griko molti derby
e anno sia la forma attiva che quella
riflessiva come ad esempio briscoe io
trovo briscoe ma io mi trovo anno io
perdo cannone
io mi perdo ci sono però verbi che hanno
solo la forma attiva come ad esempio ma
ho io vado petto
io cado cole mo ed altri ci sono poi
verbi che hanno solo forma medio passiva
però hanno significato attivo come ad
esempio fe no me io sembro air come io
vengo forio me ho paura eccetera
e veniamo alla forma passiva la forma
passiva italiana in genere in grigo e
poco usata si preferisce rendere attiva
la frase anziché dire ad esempio il
cavallo e il legato dal contadino
si preferisce dire il contadino lega il
cavallo comunque nello schema della
diapositiva abbiamo riportato colorato
in azzurro il presente l''imperfetto
indicativo nella forma passiva formata
dal verbo in e io sono più il participio
passato del verbo comunque anziché dire
ivo imed e meno io sono legato posso
anche usare il verbo air come al posto
di me e quindi dire ivo air come de meno
io vengo legato così come si dice dalle
prove anche in italiano
e allora incominciamo a vedere il
presente indicativo che insieme
all''imperfetto si forma dal tema del
presente del pivot del nome io mi lego i
su del setto di leghi vicino venete
egli si legga dell''onesta delle gesta
del monte a volte si sente di rate del
not an non si fa sentire il perfetto di
denaro io mi legava i del naso tutti i
legali ed è nato egli si legava iden
agosto e della sosta ed è nato il
perfetto indicativo che altro non è che
il passato prossimo
è una forma poco usata si preferisce
usare laurito cadura l''italiano mi sono
legato anziché dire e codesti si
preferisce dire destino infatti abbiamo
detto che spesso il passato prossimo in
grigo si rende col passato remoto e cioè
con l''auris lasciamo per un momento da
parte le caselle colorate in azzurro
perché sono le forme del passivo e
continuiamo
ad analizzare i modi ei tempi derivati
dall ariston dal tema della visto che ed
est quindi maurito è destino
io mi lega i testi tutti legati gesti e
gli si legò poi desti morto desti sosto
vestita il futuro en othe store
devo legarmi enna desti devi legarti
enna desti deve legarsi enna destro
mesta enna d''este sesta enna destina il
congiuntivo aristo nave store che io mi
leghi o che io mi legasse na desti che
tu ti leghi o che tutti le cassi na
desti che egli si leghi o che egli si
legasse poi nave sto mestra nave stres
espa la destina il più che perfetto
chicca dice chi chiede sconta che io mi
sia legato o che io mi fossi legato in
italiano possiamo anche dire che io mi
abbia legato o che io mi avessi legato
poi l''inter aveva visto destro l''estate
sta lega di legatevi il participio visto
the stone ta legandosi che ha sempre
valore ipotetico cioè se si fosse legato
el''infinito aristo desti e legarsi nei
riquadri colorati in azzurro abbiamo
riportato le forme passive il participio
passato che ha o meglio può avere anche
valore passivo nemmeno the many de meno
al singolare the man idem e nelle meno
al plurale si comporta come un aggettivo
a crea uccide
il presente indicativo passivo kim ed è
meno sono legato ised e meno eccetera e
l''imperfetto indica divora sivo i mono
de meno ero legato abbiamo detto che si
può formare il passivo anche con il
verbo air come er come de meno però sono
delle forme in griko poco usate e adesso
diamo un rapido sguardo alla seconda
coniugazione attiva dei verbi che hanno
l''accento sull''ultima sillaba cioè sono
rossi doni in o come il verbo a capo la
differenza fra la seconda coniugazione
della prima è che mentre la prima alle
tre persone singolari dell''indicativo
presente in o chi è degno abbiamo visto
dello danny danny a capo fa capo a gava
agapanti e quindi a capo
io amo aggrappato a mi pagava egli ama
poi a kabul è accaduto a capone
imperfetto e haga big paga piguet agati
a capo amo adeguato a gaborone ricordo
che l''imperfetto oltre all''imperfetto
indicativo italiano traduce anche il
condizionale presente quindi a gariga
può significare anche io amerei ma si
può tradurre anche con il congiuntivo
imperfetto se è preceduto dalle
congiunzioni na o anna quindi anna haag
adiga se amassi poi partire presente
alla porta e il participio passato
pagato in meno a david many ad almeno il
perfetto che corrisponde al passato
prossima italiano come abbiamo già detto
altre volte
ecco a gavin mena
io ho amato
ma posso anche tradurre che io abbia
amaro laurito haga pisa a gabicce a
garis haga pisane a kapisa della
capitale io ha mai oppure che io ho
amaro eccetera
il futuro e naga viso e naga pisi e naga
tisi enna capito nella capitale è la ga
visione io amerò ma qui
non ci soffermiamo a leggere tutti i
tempi della seconda coniugazione medio
passiva
l''unica differenza che possiamo notare
rispetto alla prima con il reazione
meglio passiva e che le desinenze che
tim e 3 desinenze del presente
indicativo della forma medio passiva
sono io né anziché come gli chiede
quindi mento ed è nota del nome del sede
è a capo fa a capirne a capire a gavi e
comunque chi vuole dare uno sguardo
magari fermi di immagine e con leggere
tutto lo schema della diapositiva e
passiamo senz''altro al secondo gruppo
della seconda coniugazione attiva dei
verdi rossi toni in o con l''accento
sull''ultima sillaba come il verbo toro
che a differenza di a capo fa toro tori
tori cioè mentre a capo lo faceva capo a
gava
agata il verbo toro appartiene a quella
classe di verbi che hanno le tre persone
singolari del presente negativo in o
sini e in tutto il resto è uguale al
verbo a capo quindi abbiamo i tempi
formati dal tema del presente
e i tempi formali al tema del laurismo
per la forma medio passiva del secondo
gruppo diverbi vediamo che è loro fatto
rione teoria se togliete esattamente
come il verbo a capo quindi le desinenze
sono uguali le prime tre desinenze del
presente in negativo prima seconda e
terza singolare sono uguali a quelle del
verbo a capo mentre per la forma attiva
erano differenti per la forma media
passiva sono le stesse
quindi diamo uno sguardo
la tabella possiamo fermare l''immagine e
leggere attentamente tutti i tempi della
seconda coniugazione medio passiva in
one
vediamo ora alcuni esempi relativi alla
forma attiva e medio passiva dei verdi a
capo e torok ottoni a capa mia catera i
così crono antonio ama una ragazza di 20
anni a gava e terza persona singolare
vedete che fa in a alla desinenza in
aria mentre il modello che apparteneva
alla prima coniugazione faceva danny
alla terza persona singolare posto seco
a gavi in meno
quanto ti ho amata e con gavin mena è il
perfetto abbiamo tradotto col passato
prossimo
ma se avessi detto penso che abbia amava
avrei comunque tradotto in riva lo
stesso mister secolo agati in meno
quindi ecco ad alimena traduce sia il
passato prossimo
indicativo sia il congiuntivo passato
italiano gratis o ater i nas e haga
visone a ma se vuoi che ti amino agapito
è imperativo ha visto ma se ha la
visione e il congiuntivo al risto
preceduto dalla congiunzione con valore
finale ma gagarin minimo gli nega a mia
amata moglie a gaby many e il patibolo
passato che si comporta quindi come un
aggettivo siccome si riferisce agli nega
che è un nome femminile
quindi abbiamo la desinenza sini
mia coraini a gabbia mostro una volta
noi ci amavamo a gabbia mosto e
l''imperfetto indicativo pagati a mosto e
l''imperfetto indicativo di formare nelle
passiva it e la paga visto me sta all
ice dio
vorrei che ci amassimo tutti e due
magari stu mesta e la forma medio
passiva del congiuntivo auris co
preceduto dalla congiunzione finale ma
se al posto di hite la che è un
imperfetto indicativo che ho tradotto
con vorrei ma poteva tradurre anche con
volevo e ci amassimo tutti e due
avessi usato il presente voglio che ci
amiamo tutti e due
avrei detto telo naga visto me sta all
ice dio quindi avrei usato la stessa
forma questo per dire che è il
congiuntivo
ho visto traduce sia l''imperfetto
congiuntivo sia il presente congiuntivo
nega pistum e sta e la formale e vasiva
di a couple haga pistis a ma poi ha
visti sa si amarono ma poi si lasciarono
tutti e due
ho visto possiamo tradurre anche col
passato prossimo si sono amati ma poi si
sono lasciati e torje casinò in black
iii non vedi che lui non vede qui
abbiamo il verbo toro è il verbo greco
che hanno una leggera sfumatura di
significato che due significano vedere
però toro significa più che altro badare
osservare stare attento insomma vedere
con gli occhi della mente più che altro
deriva da te oro da cui l''italiano
teoria mentre greco significa più
propriamente vedere con gli organi della
vista con gli occhi tories o capri preti
ipai tozzo ecco in questa frase appunto
il verbo d''oro ha proprio questo
significato di stare attento badare
guarda cioè stai attento bada che domani
piove non andare in campania
eto''o sotto risi non lo posso vedere qui
torrisi e l''infinito preceduto dal verbo
socio come sappiamo è qui però il verbo
toro ha proprio significato di vedere e
che abbiamo detto loro
anche questo significato vedere con i
colpi che con gli occhi della mente
anche con gli occhi fisici torio mesta
aprissi mesi ci vediamo domani in piazza
naturisti mesta panta gli orologi che ci
vediamo sempre per il bene
adori stu mesta e il congiuntivo aoristò
mentre torri onesta nella frase
precedente era il presente indicativo
ci vediamo della forma medio passiva
naturalmente per chi volesse
eventualmente apprendere la lingua
il consiglio che do e di memorizzare
quanto più possibile la coniugazione dei
verbi così come si fa sui libri di
scuola
so bene che è un impegno duro e faticoso
oltre che noioso però suppongo che chi
si sia avvicinato alle mie lezioni sia
animato da un forte interesse per
apprendere una lingua che come abbiamo
già avuto modo di dire altre volte un
tempo godeva dello stesso prestigio che
a oggi l''inglese se non addirittura
superiore bene vi saluto e vi do
appuntamento alla prossima lezione
ciao a tutti', FALSE),
(22, 'miHqjGYBB5o', 'Il Modo Imperativo ed Esortativo', 'verbi', 'Sistema Verbale', '11:47', 1013, 'Formazione dell''imperativo presente e aoristo singolare e plurale, con le particelle negative (''mi'' + congiuntivo) e le formule per formulare comandi ed esortazioni comunitarie.', '«Kuse cino pu so'' léi o jèro» — Ascolta con rispetto ciò che ti consiglia l''anziano.', 'cari amici ben trovati in questa nuova
lezione nella quale parleremo del modo
imperativo nelle sue varie forme attiva
e medio passiva come sappiamo
l''imperativo è il modo del comando si
usa per dare un ordine un comando sia di
compiere un''azione sia di non compierlo
e in questo caso parliamo di imperativo
negativo precisiamo innanzitutto che in
griko l''imperativo è chiamato anche
imperativo ha visto perché si forma dal
tema dell''ariston
dando uno sguardo alla diapositiva di
powerpoint
diciamo che ci sono verbi che
all''imperativo spostano l''accento sulla
terz ultima sillaba e prendono la
desinenza in saw a volte anche in o
quindi all''imperativo diventano prova
rossi doni cioè con l''accento sulla
verso l''ultima sillaba tra l''altro la
desinenza so
oppure o deriva dal greco antico dorico
son on
hulk i verdi hanno l''imperativo in hulk
e ancora con desinenza in a oppure sono
irregolari e adesso vediamo alcuni
esempi di verbi che hanno la desinenza
in su con questi sono a capo
amo che fa ha capito la seconda
singolare agati sede alla seconda
plurale ama amate apro una piccola
parentesi per ricordare che l''intera
vivo si forma dal tema della wsr risto
ad esempio laurito di a capo e haga pisa
dove haga peas e il tema è la e la
desinenza quindi l''imperativo fa a gaby
sono agapi sete haga peace è sempre il
tema del resto lo è la
sono le desinenze della seconda persona
singolare della seconda persona plurale
unatto accendo a razzo unha sete anni io
apro a nizza a nizza ha rotto domando a
rho tiso a roti sede da nizzo presto
dany dany sede bonazzo chiamo fo naso
con us ed è capito mi siedo cat is at
his and the year o rido gliela so chi e
la sete you rizzo torno iuris iuris et e
canon o guardo osservo canoni sono
canoni sepe fratello tengo oppure
trattengo crati so.crate sete lipari
aggio ingrasso lipari a saw iii pari a 7
mar io cucino mare ma resede meleto
leggo meletis nelle t sede me razzo
divido nera sono nera sede vediamo
alcuni verbi che all''inter a dio al no
la desinenza in ferno porto fair and
fair ed porta portate ikuo oculo
significa centro d''ascolto accuse fu
sede perno prendo pare pare del petto
cado pese pese de t anno
prendo tia e piacete o piante pinna bevo
via goethe
sfratto uccido spazi spazi scatto zappo
scazzi scarpe spanò rompo spose spa sede
snigour mescolo smith smiths da spiaggia
è giusto spiace spiace the snow spengo
ise isee da grifo provino threats
twitter
rho mangio fare fate vado letto male
male te briscoe provo bree che richiede
anno perdo case casette e poi questi
naturalmente ci sono anche tanti altri
adesso vediamo alcuni verdi che
all''imperativo anno la desinenza in app
oppure sono irregolari
allora azzoppò significa muoio credo
detto di animale soprattutto so fa
giocate ercole vengo tela the late
inverno entro emma in base quindi questi
hanno la desinenza in a la seconda
singolare innate alla seconda plurale
verbi che hanno l''imperativo è
irregolare sono fino a p
la da lascia lasciate che io corro
o fuggo ceo of io ne siete corri correte
pao vado
amo amate mai andate greco vedo des rete
per quanto riguarda l''imperativo
negativo
esso si forma ricorrendo alla forma
verbale del congiuntivo ha visto che noi
abbiamo già visto in una precedente
elezione
premettendo adesso la congiunzione di
natura finale in quindi se devo dire non
aprire quella porta di rho na minha
nizzi ct porta dove natalizi e il
congiuntivo aristo e sovrani sono amici
nemici non eccedere emin è la concezione
che rende l''idea del comando e trasforma
quindi il congiuntivo visto in
imperativo ha visto e adesso passiamo a
vedere il modo imperativo di forma al
medio passiva la forma medio passiva
dell''imperativo alle desinenze i nuovi
per la seconda persona singolare e inu
testa della seconda persona plurale
per quanto riguarda il interattivo
negativo esso si forma come per la forma
attiva cioè permettendo nam in oppure
più semplicemente in al congiuntivo
aristo per cui se devo dire non
arrabbiarti sempre di rho nanì rischi va
alta oppure più semplicemente i tristi
vanta e adesso passiamo a vedere come
fanno alcuni verbi di forma medio
passiva all''imperativo aprono me mi
corico applauso ha potute st arma non mi
sposo armato armas to the star
ricordo ancora che l''imperativo si forma
dal tema della wsr risto e che l''ha
visto ad esempio del verbo arma john e
io mi sposo e arma stimo 9 are must è il
tema è i
e la desinenza quindi l''imperativo fa
armas to arm astute st armas è sempre il
tema della visto la u e l''autista sono
le desinenze zeppo di non mi spoglio
secondi sto sv di stu testa di un nasone
mi spoglio
io nasco e''una student canoni one
riguardo canonisti canon eastwood e sta
fratello né mi tengo fratesco creata e
stu desta clean nome mi chiudo cristo
l''istud e sta gre nome il bagno gratu
gratuite sta come i brucia khow how the
st visone i tocco hingis to this to the
st agonia me mi affretto agonisti
agonisti desta siano non è il frigo sia
nosto siano studi sta rigone ligonchio
mi adiro cristo ristudiata sco rizone i
separo sco risto score eastwood e sta
schiaccione ea giusto schianto sia studi
sta bene concludiamo qui questa lezione
e anche questa volta vi propongo un
espressione proverbiale in griko armato
arma succede poi tori a pieghi nega
telino tritata cousteau crono e in hd su
dior onu che atera e nei mancata
traduzione sposa disposta di e poi
vedrai se prendi moglie vuole nutrita
incavo all''anno
hai un figlio entro due anni una figlia
non ti sarà mancata il presente
proverbio sottolinea che il matrimonio
comporta l''uomo molti sacrifici
egli infatti una volta sposato dovrà
lavorare per mantenere la famiglia che
in anno in anno diventerà sempre più
numerosa
vi saluto e vi do appuntamento alla
prossima lezione
ciao a tutti', FALSE),
(23, 'z0DtNawBktc', 'Il Participio Presente, Aoristo e Perfetto', 'verbi', 'Sistema Verbale', '10:17', 873, 'Studio dei participi con desinenza in -onda/-onta (presente/gerundio) e medio-passivi in -meno (perfetto attributivo), con la loro frequenza stilistica nei proverbi e nelle narrazioni orali.', '«Pernonta o chierò, perni i zoi» — Passando il tempo, passa la vita (approfitta di ogni giorno buono).', 'in questa lezione parleremo del
participio in griko abbiamo il
participio presente il participio
amorisco e il participio perfetto
participio presente si forma dal tema
del presente
se prendiamo in esame per esempio il
verbo toro esso fatto ronta vedendo il
partito iorismo si forma dal tema
dell''autismo e abbiamo tories ha per i
verbi di forma attiva turistico per i
verbi di formare medio passiva datori
sabbia motori smonta che significa
vedendo però con significato ipotetico
se avessi visto turistico significa
vedendosi con significato sempre
ipotetico se mi fossi visto il
participio per creto si forma dal tema
del risto passivo turistico e fattori
meno dovrebbe fare
tori in meno the rock attori in meno
manca il suffisso sti tipico della wsr
rischio medio passivo il participio
perfetto per in meno si comporta come un
aggettivo vero e proprio e quindi altre
uscite una per il maschile una per il
femminile è una per il neutro quindi
alcuni grammatici lo chiamano aggettivo
verbale perché proprio si comporta come
un oggettivo da torino abbiamo la forma
avverbiale torin mena che si usa nelle
forme composte dell''indicativo del
perfetto ed è più che perfetto che
traducono rispettivamente il passato
prossimo e il passato prossimo o
trapassato remoto
qui in questa diapositiva vediamo alcuni
esempi di parti cv da a fino lascio
abbiamo a fini non tre cattivi
e a ficoltà il participio aristo teniamo
presente che lauri sco e africa quindi
fa a chi conta ma ho io vado pronta a
manta questa norma un po irregolare
perché l''auris codipa e irta dio io do
ionta dopo l''arresto di bioetica quindi
partiremo visto lo punta air come vengo
air conta e conta laurito di air come è
irta quindi partecipano visto e racconta
pro mangio pronta
partecipiamo visto fanta perché l''ha
visto di pro e eva feo corro fronta
parti riverisco pilota perché l''auris 3
c a meno aspetto meno mi non t''ha l''ha
visto di meno è nina quindi partecipa
risco nino leo dico lenta conta
ho visto ibba partite ho visto conta
zero
sto stampa
sto tonta l''auris cole stati mo greco
corro reconta laurito è ed rana quindi
parteciperà visto tramonta guardo metto
va ad onta lauri score e va là quindi
artici me l''ho visto va lontano
in quest''ultima diapositiva vedremo
alcuni esempi mo cumbia se i siti toront
a local azzi cioè di fobia misura tristo
l''animo vedendo la grandine e il fuoco
questa frase tratta da una poesia
popolare
toronto e participio presente del verbo
toro mentre vedevo al valore temporale
mentre vedevo la grandine è il cuoco
torri sotto chino go e rame i su enel
ido vedendo quello che ha fatto
tu non diresti così torino tra il
participio rischio a valore ipotetico
significa se avessi visto quello che ha
fatto a nick e tori stone caso jali i
che yaris torta se si fosse visto allo
specchio si sarebbe pettinato avevamo
anche dire senza anni chiedo riscontra
semplicemente tories tonta seriali
notiamo qui che è il participio risto si
usa nelle forme opposte del più che
perfetto congiuntivo i che yaris tonta i
che rispunta teniamo presente però che
in italiano
abbiamo tradotto nella prima classe da
abbiamo tradotto se si fosse visto allo
specchio
quindi abbiamo usato il congiuntivo
travasato nella seconda frase abbiamo
prodotto si sarebbe pettinato quindi
abbiamo tradotto con il condizionale
passato conclusione il che perfetto
congiuntivo traduce sia l''italiano
congiuntivo
stato sia il condizionale passato isole
mi accadeva o d agati many era una
ragazza molto amata catera femminile
vedete che il party giro perfetto e haga
i beni con la finale desinenza del
femminile quindi si accorda con chiederà
che femminile eco a gavin mena o di
cheating i nega
ho amato molto quella donna
qui a ravina e il patito perfetto
chiederò a sotto una forma avverbiale
con la finale per che accompagna il
verbo eco nella forma composta del
perfetto indicativo ho amato che traduce
il passato prossima italiana art 30 e
sono mammiferi inasprì a la len di corsa
a casa mia per portarmi un po di sale
che onta propriamente significa fuggendo
ma noi traduciamo di corsa pronta dal
verbo 0 e participio presente si apresta
atto pericolo eni che pesa un po
fuggendo presto dal pericolo non sarebbe
caduto fiat in questo caso è partecipe
ha visto e ha valore ipotetico se fosse
fuggito riesco ad dal pericolo non
sarebbe caduto liniger mon le mogli
amato pronta mia ricetta parlava con la
bocca piena
mangiando una frisella mangiando mentre
mangiava quindi valore temporale nel
momento in cui
java fanta plana lio arte e su con i gay
cilia mangiando di meno adesso non ti
farebbe male la pancia mangiando in
questo caso ha un valore i poteri
se avessi mangiato toni da vado lumera
geografico lo vidi che emetteva fuoco al
suo campo nel momento cioè in cui
metteva nuovo a valore temporale
participio presente va lontano ancora
arte mistica di nodoso gratti mettendo
più attenzione adesso non starebbe
malato al letto volontà e participio ha
visto quindi se avesse messo più
attenzione bene questo è tutto sullo
participio vi do appuntamento alla
prossima lezione che sarà sui verbi
irregolari
ciao ciao a tutti', FALSE),
(24, 'hTNUF3tSu8E', 'Verbi Irregolari, Difettivi e Impersonali', 'verbi', 'Sistema Verbale', '11:12', 794, 'Conclusione del corso grammaticale sistematico: alternanze di radice (''pao/ipia'', ''leo/ipa''), verbi difettivi ed espressioni impersonali meteorologiche e di necessità (''prepi, soddhi'').', '«Prepi na kàmome to kalò gia na vroma to kalò» — Bisogna fare il bene per poter trovare il bene.', 'cari amici benvenuti a questa lezione
sui verbi irregolari e impersonali che
conclude la lunga serie di lezioni sulle
nozioni di grammatica di lingua grica
che abbiamo pubblicato in particolare
abbiamo trattato i seguenti argomenti
come si scrive e si pronuncia il griko
questa era la lezione sull''alfabeto poi
l''articolo
il nome gli aggettivi qualificativi e
determinativi i pronomi i verbi regolari
e le varie coniugazioni gli ausiliari
gli avverbi le interiezioni bene qui
parleremo dei verbi irregolari e
impersonali i verbi irregolari in griko
sono quei verbi che non seguono le
regole generali nella formazione dei
tempi ma presentano delle anomalie sia
nel tema che nella desinenza vediamo
quindi un rapido sguardo alle seguenti
diapositive dove abbiamo riportato oltre
al significato in italiano la prima
persona singolare dell''imperfetto
dell''arresto e il participio passato
quindi abbiamo il verbo latino che
significa lascio all''imperfetto fa fin
al risto africa
participio passato a fi meno pao vado
imperfetto e va da cristo e va là
participio passato va lo meno a cà de
ven
shadow accadere ma accademica accadeva o
meno air come vengo cercavo irta art o
meno rho maggio era e fa fa meno
leo dico è la pipa o meno a me lo butto
oggetto ambe jaga ameglia sa ameglia
meno al governo
salgo ad averla
angelica albero o meno a pete no muoio a
petit nice
ap età ma avete almeno ceo brucia e cea
e caccia a meno dio da lidia e dica lo
meno fenome sembro o compagno ifema mo
iv animo fan o meno feo fuggo oppure
tolgo e bega via filomeno ferno porto
portare qui è ferma e fair a fair meno
andiamo avanti e vienna
esco in perfetto again
ho visto i big a falsi cipro passato
haga lo meno ye nome di vento oppure
maturo in perfetto yen amo ho visto
settimo yen o meno anno faccio e cannes
e cam cam o meno patito siedo i cat is
he katis cadi in meno caderno pulisco o
sbuccio
terna è katara cader meno cleo piango
hekla e class clan meno core donno
disagio cordona cordos a bordo meno suo
ascolto o sento di qua accusa un meno
amato imparo o faccio imparare e maga e
mata ma di meno in bella entro amber
indica a balo meno peggio gioco e ibiza
e pete ha reso meno perno porto la e
perna hipira per meno ricordiamo che
ferno significa portare qua perno invece
portare la petto cadeau e pet e pesa
pesa meno di no devo i team idea e o
meno o chi meno leno l''avo e plana lina
al risto li meno frigo me li gonfio i
brigan in i tristi ma nemmeno
proseguiamo spazzo uccido e spazza o es
paga e spazza sfar meno sio nuovo esiga
all''imperfetto
chi si sa al lavorista syz meno o sì o
meno al participio passato sirna tiro o
racino is here is here a sir meno sterno
semino esterna ispira per meno scrivo
volgo ott orco ispica ispica screen meno
te lo voglio
it e la hit elisa per in meno
però vedo considero storica tories
attori meno greco inseguo e greca e
trama ramo meno pro mangio e tra e fa fa
meno 0 so it''s era c''era anche
all''arresto ma ndo meno al participio
passato vado netto o inserisco e va da
sé va là va lo meno briscoe provo i
brisca idrica ri meno che reame sono
contento gli chiediamo è che resti ma
che rubano poker un metro con
seppellisco e colla e cosa come no
e qui vediamo alcuni vermi ed
espressioni impersonali abbiamo astrei
che significa lampeggia scoli gnazi fa
buio alzen e ronnie albeggia grechi
piove calogeri azi
inizia l''estate cinisi
nevica simoni azi
inizia l''inverno carnica ma fa caldo
fronta buona cani cifra fa freddo
se calizzi che origina astrei lampeggia
abbiamo anche altre espressioni
personali medina i ho fame neri ai o
freddo lunghezzina bisogna che esso
geste è possibile retina conviene che
enna devo bisogna che i debiti personali
quindi sono quei verbi che si usano
soltanto alla terza persona singolare ed
esprimono in genere fenomeni atmosferici
o condizioni del tempo come abbiamo
visto bene con questa lezione abbiamo
concluso come già detto all''inizio la
serie dedicata alla grammatica greca i
prossimi video che ho in progetto di
pubblicare riguarderanno la traduzione
in italiano di poesie e canzoni popolari
grigie tra le più fan 9 e famosa so
benissimo che le lezioni di grammatica
greca sono state per così dire un po
pesanti ma i prossimi video
penso che saranno molto più piacevoli
anche se sempre finalizzati
all''apprendimento della lingua grica vi
saluto e se volete
dal mio canale e cliccare su like ciao
ciao a tutti', FALSE),
(25, 'kEjiN6uOi08', 'Matinata (Kalinifta) — Il Canto Notturno d''Amore', 'poesia_canti', 'Poesia & Canti Tradizionali', '09:44', 868, 'Esegesi strofa per strofa di ''Kalinifta'', il componimento lirico più celebre della Grecìa Salentina scritto da Vito Domenico Palumbo. Carmine Greco ne traduce i versi, svelando le metafore notturne e la passione amorosa.', '«Evò panta se sena pensèo, jati sena, kardìa-mu, agapò» — Io penso sempre a te, perché te, cuore mio, amo.', 'cari amici ben ritrovati in questo nuovo
video che fa parte della nuova playlist
la poesia greca in cui faremo la
traduzione in italiano di alcune canzoni
e poesie grigie
questa è la volta della nota canzone
cali netta il cui titolo originale
matinata che è diventata ormai l''inno
ufficiale della grecìa salentina viene
cantata in tutte le sagre e feste
popolari del nostro salento ma è
conosciutissima anche fuori dai confini
nazionali e interpretata anche da
complessi musicali greci tra cui gli am
cardia la mattinata o mattinata è un
canto d''amore che veniva eseguito
dall''innamorato la mattina sotto le
finestre della donna amata per
svegliarla ca limita il canto più noto
come abbiamo detto della grecìa
salentina ed è stato raccolto e
rielaborato da un testo popolare dallo
studioso calimerese vito domenico
palombo
il testo che qui prendiamo in esame è
quello integrale di vito domenico
palumbo
abbiamo apportato alcune piccole
varianti lessicali per adattarlo al
brico in uso a sternatia traduzione
letterale so benissimo che non rende la
bellezza e il vero senso etico della
canzone
abbiamo preferito così per le ragioni
che abbiamo già esposto in precedenza
nel video di aree moore indine da mou
chi è felice a usi netta in oria facevo
il crono pension paese sera c''è tubisti
finestra su haga timo gli scavi amo
subito di pena
chi è il glitch ea tusini tati e noria
quanto è dolce questa notte quanto è
bella ce vò e l''hanno pensata esse sena
e io non dormo pensando a te
certo un p steven hess tra haga timo e
qui dietro alla tua finestra amore mio
chi scardi amo sunito di pena del mio
cuore ti apro la pena
i votanti disse se a pensieri ea di sena
sigillo haga po mago bao kosir no poste
oh sì cardia pappacena l''asfalto
i votanti sesena penso io
sempre a te
gli alti sena sì chi mi paga perché ben
anima mia
amo
ma pupa o bus irno coaster ma dove io
vado dove mi dirigo dove sto
siccardi amo vanta sena vasto nel mio
cuore sempre te porto in realtà siano
significa tirare però qui viene usato
nell''accezione di andare d''altronde
anche in italiano
proviamo questo senso quando usiamo
l''espressione tirare diritto per la
propria strada anche in italiano quindi
assume in questa espressione del
significato di andare acceso mai nel
magari se corriamo
e so poi se mai se ne va mai giù storia
iris sony che i nuggets napoli noi agati
noi
gesù mai e magari se oriano e tu mai non
si sa ma sti mia bella e su pony semmai
azzaman a il nonno di gol se mai i
meriti
ma incipit oria insomma è na miss mai
quelle belle labbra due non a pristina
mopy lo jaga dimena per dirmi parole d
amore benedette città ma di su mago
liceo e gliel''ha mai la mena però mentre
voci positano posterò sicar diamo
pappacena la sto città ma di su mago
liceo quel tuo occhio ammaliante dolce
engel ha mai la mela teco non ride mai
per me poveretto mentre voci bosino
austero mentre io lì dove vado dove mi
trovo
siccardi amo vanta sena vasto nel mio
cuore sempre te porto
basterà già pupa nome le pone al centro
vengo qui fisso vino mena
c''è chi è luciano leone stone a nemo da
tra ulian velino camera basterà già
cubano nell''eco né le stelline in alto
vi vedono e vengo rifugio non è ma è con
la luna parlano di nascosto unite
sceglie lo scemo leone stone anemone e
ridono e mi dicono al tempo tra hu di
amelie e camera al vento le canzoni to
oggetti sono perdute ma da ieri ahivoi
chi devo cesta lo iato impatto scopo
iatì vanta il cesena pensiero sicardi
amo parta cenava storia ma taglieggiato
ivo e chi devo ma le loro risa io non
curo e chiedevano un culo non vado alle
loro risa cesta lo iato e vado a scopo e
alle loro parole non metto attenzione ea
di panta e se la pensiero perché sempre
a te penso siccardi amo quanta sera a
vasto nel mio cuore sempre te porto ma
su romney the l''est cessino stand origin
oboe gavi in meno biglie l''onta finita
ma dacia su ceses fighi soggetto o in
meno ma su planet e l''est cessino
ma tu dormi forze e in sogno ste
d''origine e gap in meno stai vedendo
colui che è amato figlie l''onta finiva
ma dacia su che ridendo bacia i tuoi
oggetti ceses fighi sospetto
o in meno e ti stringe al soggetto ahimè
kalinitta sapinho c''è paolo
l''aia su tipo firth africo ma ruba o sir
nuovo step siccardi amo santa sede fa
sport
buonanotte rilascio e me ne vado
playa su riccò giorni che io me ne andai
amareggiato ma cova 80 agusteo ma
dovunque io vado dove mi divido il
droide prova si cambiamo fa casino da
sport nel mio cuore
sempre per il porto bene se il video vi
è piaciuto metti like e iscriviti al mio
canale youtube vi saluto e vi do
appuntamento alla prossima versione
ciao a tutti da carmine greco
all', TRUE),
(26, 'msCVBKK1dD0', 'Klama — Il Lamento Rituale della Memoria', 'poesia_canti', 'Poesia & Canti Tradizionali', '09:05', 803, 'Lettura e commento filologico di ''Klama'', il commosso canto funebre composto da Vito Domenico Palumbo. Approfondimento sull''antica tradizione dei morolòja e sul valore sacrale del lutto nelle comunità griche.', '«O thànato ''en echi kardìa» — La morte non ha cuore, ma il ricordo dei vivi la vince.', 'cari amici salve a tutti e ben ritrovati
in questo nuovo video nel quale faremo
la traduzione della bellissima canzone
del compianto cittadino calimerese
franco gordiano clama recco coriano uno
dei più grandi cultori della nostra
lingua grica è stato oltre che scrittore
e musicista anche pittore con lo
pseudonimo di moore gi clama che
significa pianto e la canzone
dell''emigrante che lascia la propria
famiglia
e i propri affetti più cari il proprio
paese natio per andare a lavorare
all''estero nella miniera l''emigrazione
purtroppo era ed è anche oggi lo
sappiamo
una delle piaghe più dolorose della
nostra società molti dei nostri genitori
per poter sfamare la famiglia erano
costretti ad andare all''estero per
trovare un lavoro ma non dimentichiamo
che anche oggi molti giovani lasciano i
loro genitori per andare al nord in
cerca di un''occupazione nostalgia e
parola greca formata da nos post che
significa ritorno e algia dolore quindi
nostalgia significa dolore del ritorno e
la nostalgia è il sentimento struggente
di chi nato e vissuto nel proprio paese
è costretto a stare lontano molto
toccanti e di grande intensità emotiva
secondo il mio parere i versi della
canzone in cui il padre il giorno della
festa di san brizio a calimera e in
procinto di partire e gli scappano alle
lacrime
i figlioletti sentono il suono della
banda e chiedono al papa il perché di
quel pianto e il papa risponde che in
quel momento sta pensando al treno che
lo porterà
il buio della miniera clama di franco
corlianò pianto telo umbria che dopo una
mi pen sez
una colazzo cena gliela solo che lo
attrae
nei mali raja vivo è una carta liso stop
and go è nato naso o andrano fai te
lohan ambria kit ho una mia bellezza
voglio ubriacarmi per non pensarci
una classe cena gliela so e lo arte
braille
piangere e ridere voglio questa sera nei
mali rajai poema canta riso con grande
rabbia io devo cantare sto fango è nato
naso o andremo pie alla luna devo
gridare mio marito se ne va sul mise del
solise degli negherà te l''ha detto una
classe delle meno
mina mosman e che mai a v che ho
albrizio cei en previste ma spa né il
seno nissena
sugli sepe sul viso e veline ge
svegliatevi
svegliatevi donne te l''ha detto una
classe delle mela venite qua a piangere
con me
nina oman e gemma iabichino abrizio
siamo rimaste da sole e passavo sangue
brizio la testa di sabrina
cei en previste asp armi e sena disse e
uomini
stanno andando a 1
tema spa ne sarebbe proprio ci stanno
andando e frattempo quel masso significa
a noi stanno andando via a noi e anche
piste ma span estesa la stone e marty
galinho strumento sena crono e tui i
dream e tu in fogli kristen mu.ma spa
cisti germania cléon fame cono jan
kristeva spa ne starà store
gli uomini se ne stanno andando stanno
partendo artica ii non store un ictus e
na crono che venga bene a vederli da qui
a un anno e due i dream e twizy kristen
è questa la nostra vita è questa la vita
dio mio
ma spa cisti germania leotta me poi se
ne vanno lì in germania piangendo con
dolore questo ma span e lo stesso quindi
ci stanno andando dove quel c non è
l''avverbio di luogo ma significa a noi
ma rasserena che cuddia is up e dacia
tutto da damian forato crono
dada io display e nuova brizio accuse di
banda usa di olio sono
ovvero me poveretti quei bambini vedono
il papa una volta all''anno
ta ta lia distech lei e neo abrizio
amare perché stai vincendo e la festa di
san brizio accuse di banda accuse di
olio sono ascolta la banda ascolta che
bel suono stereo di banda ceste cucito
sono state unes a chester ansioso treno
pensiero sto sco di nociti miniera fu
polemonta ici peten iovieno sto
ascoltando la banda e sto ascoltando
quel suono sto qui con voi e sto
pensando al treno
pensiero sto spadino ct in miniera penso
al buio di quella miniera cupole monta
igp temi alieno dove lavorando lì muore
la gente
tata di atena fi emma via di gli atei
tuyen ai suoi mara e dia o tecnico le ma
c''è g da lipari a situs patruno come
tutti badia papa perché devi andare dici
perché
gli atv iene isoli mara pedia perché
questa è la vita
poveri ragazzi o the pooh di paul e
macedoni il poveretto lavora e suda nali
pari a sea to spa crono ma tutti pavia
per ingrassare i padroni
con questo lavoro bene se questo video
vi è piaciuto like he vi do appuntamento
al prossimo
ciao ciao a tutti da cardine greco', TRUE),
(27, 'HBPfozK7mmg', 'Aremu Rindinedda-mu — Il Canto della Rondine', 'poesia_canti', 'Poesia & Canti Tradizionali', '09:05', 812, 'Disamina della celebre canzone tradizionale della rondine emigrante. Il testo tocca le corde universali dell''esilio, del distacco dalla terra madre del Salento e della speranza del ritorno primaverile.', '«Aremu rindinedda-mu, pu pas petonta?» — Dimmi, rondinella mia, dove vai volando?', 'ciao a tutti sono carmine greco e vi do
il benvenuto a questa nuova lezione
cominciamo questa nuova serie di video
dedicata alle poesie e canzoni popolari
griglia con la traduzione di una delle
canzoni più note e famose aree morin di
neda mou tra l''altro interpretata anche
da carmen consoli nella nota kermesse
della notte della taranta a melpignano
aree molin di neda mou è stata scritta
dal calimerese giuseppe aprile obbligata
agli inizi del novecento dallo studioso
vito domenico palumbo nella rivista cali
nera e musicata da un non meglio
identificato un maestro costanzo che
avrebbe composto anche la musica
dell''altrettanto famosa poesia matinata
meglio nota come kalinitta in aree morin
di neda il poeta sta seduto in riva al
mare è attanagliato dalla nostalgia per
il paese lontano osserva il volteggiare
di una rondine nella stagione
primaverile e immagina che venga da
paesi lontani e che forse sia passata
anche del suo paese natio alla rondine
il poeta chiede dei suoi genitori ma per
quante domande rivolga
la rondine continuando a volteggiare nel
cielo rimane muta nel tradurre il testo
abbiamo cercato di attenerci ad una
traduzione letterale
per quanto possibile consapevoli che
spesso è molto difficile rendere le
letteralmente il significato è un testo
poetico la lingua ad un''altra ma abbiamo
preferito la traduzione letterale perché
lo scopo dei miei video è sempre quello
di fare apprendere la lingua grica
a remo millin ed amo le athalassa saga
di cea tutte specie stati né tutto
calogero aree morin di neda ma chissà
mia ronghi nella quale mare ti caccia
sarebbe letteralmente però possiamo
tradurre da quale mare provieni
c''è appunto estese stanzino e da dove
stai arrivando me tutto calocero con
questo del tempo bastato petto nastro
madre bastate sale st briko lorne mare
ci aiuta i still aniti bastato petto
nastro ai il petto bianco madre bastate
sale nere hai le ali stabri col orte
mare d''orcia color del mare cei tuta di
dio antico e la coda in due aperta
vediamo che lord e mare sono delle
parole italiane in griko abbiamo anche
la parola thalassa per indicare il mare
è anche il poeta la usa come nella
strofa precedente però qui l''autore ha
preferito usare il termine mare per una
assonanza con il verso precedente e cioè
con ale iq da east di vanity noi a
sternatia la rondine la chiamiamo
assalite da che diminutivo di assaliti
termine con cui indichiamo le forbici
quindi a salite da richiama proprio
l''idea delle forbici proprio perché al
coda aperta in 2h di meno ambrosi
thalassa ivo seca non ho io l''herne
gioca lei lyon ghizzi tornerò
cadi meno ambrosi thalassa seduto vicino
al mare
ivo seca non ho io pi
osservo lio l''herne yoga lei un po ti
alzi un po ti abbassi gli indizi tornerò
un po tocchi sfiori l''arpa a remo play a
ischia
lei un topo ei avon man a u e chi glie
non era tipo l''idea
a remo clea paesi a chissà quali paesi
l''europa e la romena quali luoghi hai
attraversato e chi viene meno 9 a il
costruito tifo dea iso nido tu a nizza
ratiglia ricche abuso the ice man a
possa prama da ises era solo la musica
ha liberati gli avi che significa se
sapessi che sei passata a porterà il
seme na da quelle parti da me possa
trama thais sena quante cose a the sun
otò amo chi ti chiedo di dirmi ma su
tipo tipo lei mia possa serrato
io a hyères mi dica lei gli indizi
tornerò ma su tipo timo lei ma tu niente
di ci dia possa serrato per quante cose
io ti domandi lio agliardi
io a lei un po dialisi in pochi a bassi
gli indizi troverò un con tocchi l''acqua
serrato a thin man amo ho addosso a
gavin man i vecchi tosto da me many
nastasi lame di serrato a thin man amo
ti chiedo di via madre fu addosso alla
di meghni che è tanto amava pure chi
posso camerini che è tanto che mi
aspetta una stagione di di arrivare per
potermi vedere per vederlo
sero co atto zurigo azioni indie donia
amici o mi dia o sai che non amo di sé
rotolato giù rino ti chiedo di mio padre
matteoli sintonia di tutto il vicinato
amici o mi dia se avessi la parola possa
ice namo p
quante cose avresti da dirmi ma suo tipo
di mou lei lì apposta serono gli odierni
yoga lei gli indizi tornerò ma su tipo
timo lei ma tu niente mi dici io possa
serono per quante cose io ti chiedo io
l''herne yoga lei un po ti alzi un po ti
abbassi calais sarebbe proprio un pò
cali gli indizi tornerò un po trucchi
l''acqua
vi saluto e vi do appuntamento al
prossimo video
ciao ciao', TRUE),
(28, '1aPLzdvMZD8', 'Agapi-mu Fidela Protinì — Primo Fedele Amore', 'poesia_canti', 'Poesia & Canti Tradizionali', '10:31', 599, 'Lettura metrica e spiegazione della poesia popolare d''amore fedele. Carmine Greco illustra le figure retoriche contadine, il pudore sentimentale e la musicalità tipica della poesia orale salentina.', '«Agapi-mu fidela protinì, ''en se lestièo mai» — Mio primo fedele amore, non ti dimenticherò mai.', 'cari amici
ben ritrovati in questo nuovo video vi
propongo una bellissima poesia popolare
dal titolo agatino fidel a rotini mio
primo fedele amore la canzone che
ascoltate e stata tratta dall''album del
gruppo musicale ghetonìa dal titolo
marie lune ad est del sud
la musica è di salvatore cotardo le voci
di roberto licci ed emilia ottaviano è
una poesia dolcissima secondo il mio
parere con un alto contenuto poetico e
con delle immagini che ci infondono
forti emozioni
la donna si trova nel suo campicello
intento a raccogliere lino ed ecco il
suo folgorante improvviso apparire in
mezzo al verde agli occhi del giovane
innamorato lo sconosciuto autore della
poesia usa un termine molto suggestivo e
di grande effetto di cederla keys è
ammessa stop coloro lampeggio in mezzo
al verde è come se l''innamorato venisse
folgorato alla vista della donna che ama
la quale brilla in mezzo al verde dei
calchi altri versi di forte impatto
emotivo sono quelli in cui traspare la
timidezza dei due giovani lei che alla
vista dell''uomo si nasconde tra l''erba
per non farsi vedere
e lui che si allontana ma senza
distogliere lo sguardo dal punto in cui
era apparsa la donna amata
mangiando
o no
scoprirete o precari
il disco meteo ferrari
anno nuovo
no
bene faremo anche qui una traduzione
letterale cercando di far coincidere per
quanto possibile i termini grilli con
quelli italiani
agatino fidel aprutini mio primo fedele
amore stock ora fa c su siano né linari
cederla ti sei messa stock loro secondo
1 tascone devo fangari atto crovatti di
orio rettore stock ora facis siano né
linari nel tuo campicello raccoglie e
velino ceder lampis emessa stroke loro e
lampeggianti in mezzo al verde
secondo moscone devo fangari come quando
si alza la luna atto provati glorio fare
stop dal letto suo bello splendido
di martino
vedi
le mani
9
e un mani
saviano
mid e cercati se cado st corti a for his
tina bro sena maneki taras astuto leone
di cardia capo di a pian ambro trama di
ampi mi de ceccaty seccato st corti a mi
vedeste e ti nasconde sti tra le erbe
letteralmente sarebbe e ti sei seduta
sotto al r for his tina bro sena maneki
the mesti di trovare te da sola taras ma
sudo leone di cardia me ne andai
ma te lo dico con il cuore capo di a
pian ambro armadio ampi i piedi andavano
avanti gli occhi indietro
prodi
1
a darle una mano
agatino fidel a proteine loro dignità a
sino settore
ivo azzo non tasse briscoe cc otama la
clava anch''iò agatino fidel a provini
mio primo fedele amore puro dignità
assino se però anche la notte in sogno
chi vedo vivo azzurro tas s briscoe c
ios degli angoli non ti vedo lì ci aiuta
ma la clava tra anci gnocchi e così i
grandi pianti incomincio
masi
ti stanca
traguardo
ma
no no no
diciamo no
no
chi naga primo valesi city secondo
sicardi a motivi vasto i 90 su cosmo
parolisi secondo sa capone e naga visi
tina galimov alesi city il mio amore
netti nell''anima
secondo sicardi a mo di un bastone come
nel mio cuore io ce l''ho ito panta su
cosmopolitan sisi così sempre nel mondo
va la vita
torrisi letteralmente sarebbe il vivere
secondo sa capone e naga visi come ti
amano
devi amare bene ci fermiamo qui
speriamo che il video vi sia piaciuto e
se vi è piaciuto mi raccomando live
iscrivetevi al dio canale ciao ciao a
tutti da carmine greco', TRUE)
ON CONFLICT (video_id) DO UPDATE SET
    titolo = EXCLUDED.titolo,
    categoria = EXCLUDED.categoria,
    categoria_label = EXCLUDED.categoria_label,
    durata = EXCLUDED.durata,
    conteggio_parole = EXCLUDED.conteggio_parole,
    sommario = EXCLUDED.sommario,
    proverbio_chiave = EXCLUDED.proverbio_chiave,
    trascrizione = EXCLUDED.trascrizione,
    is_poetry = EXCLUDED.is_poetry;
