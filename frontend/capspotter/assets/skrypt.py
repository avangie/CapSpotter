import sqlite3

# Połączenie z bazą danych
db_path = 'mushrooms.db'  # Podaj ścieżkę do swojej bazy danych
connection = sqlite3.connect(db_path)
cursor = connection.cursor()

# Dodanie kolumny na polskie nazwy, jeśli jeszcze nie istnieje
cursor.execute("""
    ALTER TABLE Mushrooms 
    ADD COLUMN name_polish TEXT
""")
print("Dodano kolumnę 'name_polish' do tabeli Mushrooms (jeśli wcześniej nie istniała).")

# Słownik z polskimi nazwami
polish_names = {
    'Agaricus_augustus': 'Pieczarka okazała',
    'Agaricus_xanthodermus': 'Pieczarka karbolowa',
    'Amanita_muscaria': 'Muchomor czerwony',
    'Amanita_phalloides': 'Muchomor sromotnikowy',
    'Amanita_rubescens': 'Muchomor czerwieniejący',
    'Armillaria_mellea': 'Opieńka miodowa',
    'Armillaria_tabescens': 'Opieńka bezpierścieniowa',
    'Artomyces_pyxidatus': 'Świecznik rozgałęziony',
    'Bolbitius_titubans': 'Gnojanka żółtawa',
    'Cerioporus_squamosus': 'Żagwiak łuskowaty',
    'Chlorophyllum_brunneum': 'Czubajnik ogrodowy',
    'Clitocybe_nuda': 'Gąsówka fioletowawa',
    'Coprinellus_micaceus': 'Czernidłak błyszczący',
    'Coprinopsis_lagopus': 'Czernidłak srokaty',
    'Coprinus_comatus': 'Czernidłak kołpakowaty',
    'Crucibulum_laeve': 'Kubecznik pospolity',
    'Daedaleopsis_confragosa': 'Gmatwica chropowata',
    'Flammulina_velutipes': 'Płomiennica zimowa',
    'Galerina_marginata': 'Hełmówka obrzeżona',
    'Ganoderma_applanatum': 'Lakownica spłaszczona',
    'Ganoderma_oregonense': 'Lakownica oregońska',
    'Gliophorus_psittacinus': 'Grzybówka papuzia',
    'Gloeophyllum_sepiarium': 'Żylica siarkowa',
    'Grifola_frondosa': 'Żagwica listkowata',
    'Gymnopilus_luteofolius': 'Łysostopek złocistozarodnikowy',
    'Hericium_coralloides': 'Soplówka gałęzista',
    'Hericium_erinaceus': 'Soplówka jeżowata',
    'Hygrophoropsis_aurantiaca': 'Lisówka pomarańczowa',
    'Hypholoma_fasciculare': 'Maślanka wiązkowa',
    'Hypholoma_lateritium': 'Maślanka ceglastawa',
    'Ischnoderma_resinosum': 'Żagiew żywicowata',
    'Lacrymaria_lacrymabunda': 'Czernidłak łzawy',
    'Laetiporus_sulphureus': 'Żółciak siarkowy',
    'Leratiomyces_ceres': 'Czernidłak ceglasty',
    'Leucoagaricus_americanus': 'Pieczarka amerykańska',
    'Leucoagaricus_leucothites': 'Pieczarka twardawa',
    'Lycogala_epidendrum': 'Wykwit piankowaty',
    'Lycoperdon_perlatum': 'Purchawka chropowata',
    'Lycoperdon_pyriforme': 'Purchawka gruszkowata',
    'Mycena_haematopus': 'Grzybówka krwista',
    'Panaeolina_foenisecii': 'Kołpaczek łąkowy',
    'Panaeolus_cinctulus': 'Kołpaczek pierścieniowy',
    'Panaeolus_papilionaceus': 'Kołpaczek motylowaty',
    'Panellus_stipticus': 'Boczniak szorstki',
    'Phaeolus_schweinitzii': 'Żagiew Schweinitza',
    'Phlebia_tremellosa': 'Wrośniak galaretowaty',
    'Phyllotopsis_nidulans': 'Błyskoporek przypominający',
    'Pleurotus_ostreatus': 'Boczniak ostrygowaty',
    'Pleurotus_pulmonarius': 'Boczniak biały',
    'Pluteus_cervinus': 'Drobnołuszczak jeleniotwarzowy',
    'Psathyrella_candolleana': 'Czernidłak kędzierzawy',
    'Pseudohydnum_gelatinosum': 'Fałszywoporek galaretowaty',
    'Psilocybe_cyanescens': 'Łysostopek niebieskawy',
    'Sarcomyxa_serotina': 'Boczniak żółtawy',
    'Schizophyllum_commune': 'Rozszczepka pospolita',
    'Stereum_ostrea': 'Skórnik ostryżowy',
    'Stropharia_rugosoannulata': 'Łysostopek ogródkowy',
    'Suillus_americanus': 'Maślak amerykański',
    'Suillus_luteus': 'Maślak zwyczajny',
    'Tapinella_atrotomentosa': 'Żagiew aksamitna',
    'Trametes_betulina': 'Wrośniak brzozowy',
    'Trametes_gibbosa': 'Wrośniak garbaty',
    'Trametes_versicolor': 'Wrośniak różnobarwny',
    'Trichaptum_biforme': 'Wrośniak wielokształtny',
    'Tricholomopsis_rutilans': 'Gąsówka rdzawa',
    'Tubaria_furfuracea': 'Tubaria suchopochwowa',
    'Tylopilus_felleus': 'Goryczak żółciowy',
    'Volvopluteus_gloiocephalus': 'Drobnołuszczak gładkogłowy'
}

# Aktualizacja danych w bazie
for latin_name, polish_name in polish_names.items():
    cursor.execute("""
        UPDATE Mushrooms
        SET name_polish = ?
        WHERE name_latin = ?
    """, (polish_name, latin_name))

print("Zaktualizowano polskie nazwy grzybów w bazie danych.")

# Zapisz zmiany i zamknij połączenie
connection.commit()
connection.close()
print("Połączenie z bazą danych zostało zamknięte.")
