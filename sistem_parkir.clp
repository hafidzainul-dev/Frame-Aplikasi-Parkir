(defclass JENISKENDARAAN
	(is-a USER)
	(slot Tipe 
		(visibility public)
        (default MOTOR)
        (allowed-values MOTOR MOBIL)
    )
)

(defclass KENDARAAN
	(is-a JENISKENDARAAN)
	(slot PlatNomor 
        (type STRING)
    )

	(message-handler Jumlah_Space after)
)

(defclass TIKET
	(is-a KENDARAAN)
    (slot NomorTiket 
        (type STRING)
        (visibility public)
    )
	(slot JamMasuk 
        (type INSTANCE)
		(visibility public)
    )
	(slot JamKeluar 
        (type INSTANCE)
		(visibility public)
        (create-accessor read-write)
    )
	(slot RecKendaraan 
        (type INSTANCE)
		(visibility public) 
		(allowed-classes KENDARAAN)
        (create-accessor read-write)
    )
    (slot TempatParkir 
        (type INSTANCE)
		(visibility public) 
        (allowed-classes TEMPATPARKIR)
        (create-accessor read-write)
    )
	(slot Harga 
        (type NUMBER)
		(visibility public) 
        (create-accessor read-write)
    )

	(message-handler Tempat_Parkir after)
	(message-handler Cetak_Nomor_Tiket after)
)

(defclass TEMPATPARKIR
	(is-a TIKET)
	(slot TipeParkir 
        (type STRING)
		(visibility public) 
        (create-accessor read-write)
    )
	(slot Nama 
        (type STRING)
    )
	(slot Space 
        (type NUMBER)
		(visibility public) 
        (create-accessor read-write)
    )
)

(defclass CHECKOUT
	(is-a TIKET)
	(slot WaktuKeluar 
        (type NUMBER)
		(visibility public) 
        (create-accessor read-write)
    )
	(slot TiketKendaraan 
        (type INSTANCE)
		(allowed-classes TIKET)
        (create-accessor read-write)
    )

	(message-handler Tambah_Jam_Keluar after)
	(message-handler Total_Tagihan after)
)

(deffunction generateTiket (?strChar)
    (bind ?cnt 10)
    (while (> ?cnt 0)
        (bind ?temp (random 65 90))
        (bind ?chr (format nil "%c" ?temp))
        (bind ?strChar (sym-cat ?strChar ?chr))
        (bind ?cnt (- ?cnt 1)))
    (return ?strChar)
)

(defmessage-handler KENDARAAN Jumlah_Space ()
    (if (eq ?self:Tipe MOTOR)
        then 1 ;space used for parkir MOTOR
        else 2 ;space used for parkir MOBIL
    )
)

(defmessage-handler TIKET Tempat_Parkir ()
    ; (bind ?kendaraan ?self:RecKendaraan)
    (bind ?price 
        (if (eq ?self:Tipe MOTOR)
            then 2000
            else 5000
        ))
    (bind ?availSpace 
        (if (eq ?self:Tipe MOTOR)
            then 50
            else 100
        ))
    (bind ?tipeParkir 
        (if (eq ?self:Tipe MOTOR)
            then ParkirMotor
            else ParkirMobil
        ))
    (bind ?nama 
        (if (eq ?self:Tipe MOTOR)
            then "Parkiran Motor"
            else "Parkiran Mobil"
        ))
    (bind ?temp (make-instance TempatParkir1 of TEMPATPARKIR
        (Nama ?nama)
        (TipeParkir ?tipeParkir)
        (Space ?availSpace)
        (Harga ?price)
    ))
    (println "Nama: " ?nama)
    (println "Tipe Parkir: " ?tipeParkir)
    (println "Space: " ?availSpace)
    (println "Harga: " ?price)

    (bind ?self:Harga ?price)
    (bind ?self:TempatParkir ?temp)
    (return ?temp)
)

(defmessage-handler CHECKOUT Total_Tagihan ()
    (bind ?jamMasuk (string-to-field (sub-string 1 2 ?self:JamMasuk)))
    (bind ?jamKeluar (string-to-field (sub-string 1 2 ?self:JamKeluar)))
    (bind ?totalTagihan (* ?self:Harga (- ?jamKeluar ?jamMasuk)))
    (println "Total Tagihan: " ?totalTagihan)
)

(defmessage-handler TIKET Cetak_Nomor_Tiket ()
    (seed 2357)
    (if (eq ?self:NomorTiket "")
        then
            (bind ?temp (generateTiket ""))
            (bind ?self:NomorTiket ?temp)
    )
)

(defmessage-handler CHECKOUT Tambah_Jam_Keluar (?jamKeluar)
    (bind ?self:JamKeluar ?jamKeluar)
)

(definstances skenario1
	(Motor1 of KENDARAAN
		(Tipe MOTOR)
		(PlatNomor "N1234AL")
	)
	(Tiket1 of TIKET
		(RecKendaraan Motor1)
	)
    (Checkout of CHECKOUT
		(JamMasuk 13:00)
        (TiketKendaraan Tiket1)
    )
    (Mobil1 of KENDARAAN
        (Tipe MOBIL)
        (PlatNomor "D 3790 BF")
    )
    (Tiket3 of TIKET
        (RecKendaraan Mobil1)
    )
    (Checkout1 of CHECKOUT
        (JamMasuk 10:00)
        (TiketKendaraan Tiket3)
    )
)
