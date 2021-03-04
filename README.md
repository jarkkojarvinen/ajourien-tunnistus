# Ajourien tunnistus - UTU

Ohessa viestintää sähköpostista. Uusin ensimmäisenä.

## 1.3.2021 Paavo:
> xForw on siis indeksijoukko, jolla tehdään semmoinen sivulle nytkäytys (horisontaalisesti oikealle). Voit toteuttaa sen pythonilla miten tykkäät, kunhan vaan saadaan kuvasta kopio, jossa pikselit on nytkäytetty. Jossain python imlib tms. saattaa olla vastaava jo. Idea on siis, että ehkä useissa kohdissa tarvitsee viitata pikseliin ja sen oikealla olevaan pikdeliin, ja tämä tehdäämn muistia tuhlailevasti (mutta nopeasti) tässä ilman luuppeja. Silloin tulee kysymykseksi se, mitä arvoja laitetaan paljastuville pikseleille? (Esim. 1,1,2,3 tuohon ekaan paikkaan?)

> Oikea vastaus olisi: jotain kuvan ulkopuolelta vasemmalta, jos siellä esim. olisi naapuritiilikuva. Mutta kun ei ole, niin annetaan arvojen monistua. Tämä johtaa siihen, että suunnatut kaarevuudet ovat suunnilleen kunnossa vain välillä 2...(nx-1). Mutta eipä sillä juuri ole väliä. Tässä sovelluksessa on vielä tuo maskibitti. Kannattaa ehkä tehdä kaksi versiota. Toinen, jossa ei ole maskibittiä eikä sitä pikselien täyttöä (Jonne ehkä tietää, mikä on virallinen termi. Tulos siis lasketaan "3 x useammalle pikselille kuin kaava varsinaisesti sallii...") Sellainen koodi on selkeämpi. Sitten kun se toimii, lisäät nuo ominaisuudet.
> Yksi asia unohtui vielä: ehkä pystyt modularisoimaan ongelman siten, että lasket aina kaikki pikselit kattavan tapauksen, ja kutsut ylempää kuvilla, jotka on harvennettu (valittu aktiivinen osa kuvasta osatehtäväksi). Mutta tässä painaa nopeus hiukan: eli laskentanopeus määrää mitä valitset. Muistia taas voi tuhlata.

> Ohessa yhden kurssin luento, jossa on sinulle asiaa kalvoissa #30 ja #31. Muun houreen voit skipata. ;) Kalvossa #31 on muistin käyttö, eli sopivasti optimoituna muistia kuluu 5 x syötekuvan valitun pikselisetin verran.  Tämän optimoinnin voisit jättää kolmanteen vaiheeseen eli:
> 1) kaikki pikselit (eka versio)
> 2) osapikselijoukoisyta tapahtuva sommittelu (toivottavasti siten, että kutsuu toteutusta 1))
> 3) mahdollinen muistin optimointi ja naapurikuvista tapahtuva pikselien lainailu

---
## 27.2.2021 Paavo:

> https://www.mathworks.com/help/images/ref/entropyfilt.html

> - laskettu 9 x 9 -ikkunalla, voisi olla jokin muukin
> - entropiakaava: https://www.mathworks.com/help/images/ref/entropy.html
>   - aika siisti toteutus, jossain python -palikoissa ehkä samanlainen
>   - vastaava pythonisaatio voisi olla lähellä https://scikit-image.org/docs/dev/auto_examples/filters/plot_entropy.html
>   - mutta ehkä tuo 256 arvoon granularisointi ja 9x9 -ikkuna olisivat hyvät. Ikkunan koko riippuu gridikoosta \delta. Ikkunan pitäisi hyvin mahduttaa sisäänsä vierekkäiset urat ja hiukan ympäristöä

> - lähettämässäni koodissa lasketaan 1 + 3 kuvaa (jäkimmäiset hiukan shiftattuina) niin että lopullisen kuvan delta' := delta/2 (mukana 3 x lisää pikseleitä...). Tämä ominaisuus kannattaa jättää aluksi pois elilasket vaan "harvasti valituilla" pikseleillä kuvan.

> Homman voi sisällyttää maanpinnan oletuskorkeuden, josta urien syvyys sitten aikanaan lasketaan. Oletuskorkeuspinta on jokin sopivasti smoothattu pinta. Sillä pitäisi olla bias == 0 eli ei tasoita liikaa.

> Eli voit valita itse, etenetkö suurten datojen nopean laskennan suuntaan (valtakunnallinen suunnattu kaarevuus 2 m datasta) vai pukkaatko erikoisominaisuuksia mukaan. Juliakoodi olisi hyvä, jos mahdollista, mutta varmaan python ekaksi.

---

## 22.2.2021 Paavo:

Alkuperäisessä readme.txt tiedostossa oli tämä sisältö:

> Yhteystiedot:
> {antti.raatevaara,eero.holmstrom,paula.jylha}@luke.fi
> jarkjar@utu.fi, jarkko.jarvinen@gmail.com

> ja pahoittelut, että vastaukset tulee välillä vähän viiveellä. Mikäli olen oikein asian ymmärtänyt, tavoite olisi aluksi määrittää ajouran karkea sijainti, joka tulisi koneen GPS-sijainnin kautta. Kun tiedetään, että ajokone on kulkenut tässä kohtaa korkeusmallia, tulisi kuvasta erottaa uran keskikohta. Keskikohdan määrittäminen on ymmärtääkseni edellytys uran suunnan laskennalle, joka täytyy tuntea, jotta voidaan kohdistaa linja kohtisuoraan ajouraa vasten (kuva).

> Kun syvyysprofiili tunnetaan, voidaan vihdoin molempien raiteiden syvyydet laskea. Esim. lokaalien minimien laskenta voisi toimia. Referenssitason määrittäminen onkin sitten haastavampaa, sillä uran keskikohta tuppaa nousemaan havutuksen myätä. Referenssi tulisi ehkä hakea hieman kauempaa ajouran ulkopuolelta.

> Menetelmistä kaarevuusanalyysi kuulostaa minusta paremmalta. Pistepilveä ei näistä nykyisistä kohteista ole saatavilla, eikä peruutus DEMmistä pistepilveen paranna informaatiota puiden alta ollenkaan. Minusta voisi olla hyvä idea keskittyä paperissa yhteen, melko hyvin rajattuun menetelmään ja tavoitteeseen. Olen itseasiassa käynyt käsipelillä laskemassa arvioita urasyvyyksistä Kouvolan korkeusmallista, jota voisi ehkä käyttää vertailuun.

> Toki mittauksia tehtiin ihan metsässäkin, mutta niistä ei ole tarkkaa sijaintitietoa.

### Sähköpostin saateteksti

> Ohessa koodi (Lisätty versionhallintaan), jossa oli yxi bugi ja lisäsin myös kaltevuuden (s, slope). Tästä eteenpäin homma kehkeytyisi siten, että nuo ajourat pitäisi esim. digitoida käsin ja sitten nuuhkia esiin urasyvyys. Kun se toimii hyvin, niin voi lisätä ajourien automaattisen tunnistamisen (joka edellyttää opettamista).

---

## 16.2.2021

> Tehtävä: etsi renkaanjäljet tai teliketju-urat photogrmmetrisesta datasta.
> Ohessa tekemäni viime vloppuna tekemäni aloitusnykäys. Tuossa olisi:

> a) nykyisen koodin muunto: matlab --> python ja/tai julia
> b) kaarevuus- ja slopehistogrammit --> vektorit --> klusterointi- ja luokittelukyky
> c) jo ehtii/pystyy/haluaa, niin sama CNN:llä.

> Saan hänelle matlab -koodit a) + b) ja sinä voisit ohjata tuon c). Onko sinulla ollut yhteyksiä Metsätehon suuntaan, vaiko vain Heikkosen suuntaan?

> Oheisena on doku vaiheesta a). Hyvin simppeli, mutta rinnakkaistaminen ja moniprosessointi vaativat taitoa ja viitseliäisyyttä. Tämän palikan voisi julkaista -uhm- muille tutkijoille kaa.
