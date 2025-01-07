# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Si se reinicia la base de datos, descomentar estas líneas
# Spree::Core::Engine.load_seed if defined?(Spree::Core)
# Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

provincia_list = [
 	[ 1,'Arica',523],
	[ 2,'Parinacota',523],
	[ 3,'Iquique',534],
	[ 4,'El Tamarugal',534],
	[ 5,'Antofagasta',522],
	[ 6,'El Loa',522],
	[ 7,'Tocopilla',522],
	[ 8,'Chañaral',525],
	[ 9,'Copiapó',525],
	[ 10,'Huasco',525],
	[ 11,'Choapa',527],
	[ 12,'Elqui',527],
	[ 13,'Limarí',527],
	[ 14,'Isla de Pascua',535],
	[ 15,'Los Andes',535],
	[ 16,'Petorca',535],
	[ 17,'Quillota',535],
	[ 18,'San Antonio',535],
	[ 19,'San Felipe de Aconcagua',535],
	[ 20,'Valparaiso',535],
	[ 21,'Chacabuco',533],
	[ 22,'Cordillera',533],
	[ 23,'Maipo',533],
	[ 24,'Melipilla',533],
	[ 25,'Santiago',533],
	[ 26,'Talagante',533],
	[ 27,'Cachapoal',528],
	[ 28,'Cardenal Caro',528],
	[ 29,'Colchagua',528],
	[ 30,'Cauquenes',532],
	[ 31,'Curicó',532],
	[ 32,'Linares',532],
	[ 33,'Talca',532],
	[ 34,'Arauco',526],
	[ 35,'Bio Bío',526],
	[ 36,'Concepción',526],
	[ 37,'Ñuble',526],
	[ 38,'Cautín',524],
	[ 39,'Malleco',524],
	[ 40,'Valdivia',530],
	[ 41,'Ranco',530],
	[ 42,'Chiloé',529],
	[ 43,'Llanquihue',529],
	[ 44,'Osorno',529],
	[ 45,'Palena',529],
	[ 46,'Aisén',521],
	[ 47,'Capitán Prat',521],
	[ 48,'Coihaique',521],
	[ 49,'General Carrera',521],
	[ 50,'Antártica Chilena',531],
	[ 51,'Magallanes',531],
	[ 52,'Tierra del Fuego',531],
	[ 53,'Última Esperanza',531]
]
begin
	provincia_list.each do |id, name, spree_state_id|
	  Province.create( id: id, name: name, spree_state_id: spree_state_id )
	end
rescue Exception => e
	puts 'Provincias ya agregadas'
end

comuna_list = [
  [1,'Arica',1],
	[2,'Camarones',1],
	[3,'General Lagos',2],
	[4,'Putre',2],
	[5,'Alto Hospicio',3],
	[6,'Iquique',3],
	[7,'Camiña',4],
	[8,'Colchane',4],
	[9,'Huara',4],
	[10,'Pica',4],
	[11,'Pozo Almonte',4],
	[12,'Antofagasta',5],
	[13,'Mejillones',5],
	[14,'Sierra Gorda',5],
	[15,'Taltal',5],
	[16,'Calama',6],
	[17,'Ollague',6],
	[18,'San Pedro de Atacama',6],
	[19,'María Elena',7],
	[20,'Tocopilla',7],
	[21,'Chañaral',8],
	[22,'Diego de Almagro',8],
	[23,'Caldera',9],
	[24,'Copiapó',9],
	[25,'Tierra Amarilla',9],
	[26,'Alto del Carmen',10],
	[27,'Freirina',10],
	[28,'Huasco',10],
	[29,'Vallenar',10],
	[30,'Canela',11],
	[31,'Illapel',11],
	[32,'Los Vilos',11],
	[33,'Salamanca',11],
	[34,'Andacollo',12],
	[35,'Coquimbo',12],
	[36,'La Higuera',12],
	[37,'La Serena',12],
	[38,'Paihuaco',12],
	[39,'Vicuña',12],
	[40,'Combarbalá',13],
	[41,'Monte Patria',13],
	[42,'Ovalle',13],
	[43,'Punitaqui',13],
	[44,'Río Hurtado',13],
	[45,'Isla de Pascua',14],
	[46,'Calle Larga',15],
	[47,'Los Andes',15],
	[48,'Rinconada',15],
	[49,'San Esteban',15],
	[50,'La Ligua',16],
	[51,'Papudo',16],
	[52,'Petorca',16],
	[53,'Zapallar',16],
	[54,'Hijuelas',17],
	[55,'La Calera',17],
	[56,'La Cruz',17],
	[57,'Limache',17],
	[58,'Nogales',17],
	[59,'Olmué',17],
	[60,'Quillota',17],
	[61,'Algarrobo',18],
	[62,'Cartagena',18],
	[63,'El Quisco',18],
	[64,'El Tabo',18],
	[65,'San Antonio',18],
	[66,'Santo Domingo',18],
	[67,'Catemu',19],
	[68,'Llaillay',19],
	[69,'Panquehue',19],
	[70,'Putaendo',19],
	[71,'San Felipe',19],
	[72,'Santa María',19],
	[73,'Casablanca',20],
	[74,'Concón',20],
	[75,'Juan Fernández',20],
	[76,'Puchuncaví',20],
	[77,'Quilpué',20],
	[78,'Quintero',20],
	[79,'Valparaíso',20],
	[80,'Villa Alemana',20],
	[81,'Viña del Mar',20],
	[82,'Colina',21],
	[83,'Lampa',21],
	[84,'Tiltil',21],
	[85,'Pirque',22],
	[86,'Puente Alto',22],
	[87,'San José de Maipo',22],
	[88,'Buin',23],
	[89,'Calera de Tango',23],
	[90,'Paine',23],
	[91,'San Bernardo',23],
	[92,'Alhué',24],
	[93,'Curacaví',24],
	[94,'María Pinto',24],
	[95,'Melipilla',24],
	[96,'San Pedro',24],
	[97,'Cerrillos',25],
	[98,'Cerro Navia',25],
	[99,'Conchalí',25],
	[100,'El Bosque',25],
	[101,'Estación Central',25],
	[102,'Huechuraba',25],
	[103,'Independencia',25],
	[104,'La Cisterna',25],
	[105,'La Granja',25],
	[106,'La Florida',25],
	[107,'La Pintana',25],
	[108,'La Reina',25],
	[109,'Las Condes',25],
	[110,'Lo Barnechea',25],
	[111,'Lo Espejo',25],
	[112,'Lo Prado',25],
	[113,'Macul',25],
	[114,'Maipú',25],
	[115,'Ñuñoa',25],
	[116,'Pedro Aguirre Cerda',25],
	[117,'Peñalolén',25],
	[118,'Providencia',25],
	[119,'Pudahuel',25],
	[120,'Quilicura',25],
	[121,'Quinta Normal',25],
	[122,'Recoleta',25],
	[123,'Renca',25],
	[124,'San Miguel',25],
	[125,'San Joaquín',25],
	[126,'San Ramón',25],
	[127,'Santiago',25],
	[128,'Vitacura',25],
	[129,'El Monte',26],
	[130,'Isla de Maipo',26],
	[131,'Padre Hurtado',26],
	[132,'Peñaflor',26],
	[133,'Talagante',26],
	[134,'Codegua',27],
	[135,'Coínco',27],
	[136,'Coltauco',27],
	[137,'Doñihue',27],
	[138,'Graneros',27],
	[139,'Las Cabras',27],
	[140,'Machalí',27],
	[141,'Malloa',27],
	[142,'Mostazal',27],
	[143,'Olivar',27],
	[144,'Peumo',27],
	[145,'Pichidegua',27],
	[146,'Quinta de Tilcoco',27],
	[147,'Rancagua',27],
	[148,'Rengo',27],
	[149,'Requínoa',27],
	[150,'San Vicente de Tagua Tagua',27],
	[151,'La Estrella',28],
	[152,'Litueche',28],
	[153,'Marchihue',28],
	[154,'Navidad',28],
	[155,'Peredones',28],
	[156,'Pichilemu',28],
	[157,'Chépica',29],
	[158,'Chimbarongo',29],
	[159,'Lolol',29],
	[160,'Nancagua',29],
	[161,'Palmilla',29],
	[162,'Peralillo',29],
	[163,'Placilla',29],
	[164,'Pumanque',29],
	[165,'San Fernando',29],
	[166,'Santa Cruz',29],
	[167,'Cauquenes',30],
	[168,'Chanco',30],
	[169,'Pelluhue',30],
	[170,'Curicó',31],
	[171,'Hualañé',31],
	[172,'Licantén',31],
	[173,'Molina',31],
	[174,'Rauco',31],
	[175,'Romeral',31],
	[176,'Sagrada Familia',31],
	[177,'Teno',31],
	[178,'Vichuquén',31],
	[179,'Colbún',32],
	[180,'Linares',32],
	[181,'Longaví',32],
	[182,'Parral',32],
	[183,'Retiro',32],
	[184,'San Javier',32],
	[185,'Villa Alegre',32],
	[186,'Yerbas Buenas',32],
	[187,'Constitución',33],
	[188,'Curepto',33],
	[189,'Empedrado',33],
	[190,'Maule',33],
	[191,'Pelarco',33],
	[192,'Pencahue',33],
	[193,'Río Claro',33],
	[194,'San Clemente',33],
	[195,'San Rafael',33],
	[196,'Talca',33],
	[197,'Arauco',34],
	[198,'Cañete',34],
	[199,'Contulmo',34],
	[200,'Curanilahue',34],
	[201,'Lebu',34],
	[202,'Los Álamos',34],
	[203,'Tirúa',34],
	[204,'Alto Biobío',35],
	[205,'Antuco',35],
	[206,'Cabrero',35],
	[207,'Laja',35],
	[208,'Los Ángeles',35],
	[209,'Mulchén',35],
	[210,'Nacimiento',35],
	[211,'Negrete',35],
	[212,'Quilaco',35],
	[213,'Quilleco',35],
	[214,'San Rosendo',35],
	[215,'Santa Bárbara',35],
	[216,'Tucapel',35],
	[217,'Yumbel',35],
	[218,'Chiguayante',36],
	[219,'Concepción',36],
	[220,'Coronel',36],
	[221,'Florida',36],
	[222,'Hualpén',36],
	[223,'Hualqui',36],
	[224,'Lota',36],
	[225,'Penco',36],
	[226,'San Pedro de La Paz',36],
	[227,'Santa Juana',36],
	[228,'Talcahuano',36],
	[229,'Tomé',36],
	[230,'Bulnes',37],
	[231,'Chillán',37],
	[232,'Chillán Viejo',37],
	[233,'Cobquecura',37],
	[234,'Coelemu',37],
	[235,'Coihueco',37],
	[236,'El Carmen',37],
	[237,'Ninhue',37],
	[238,'Ñiquen',37],
	[239,'Pemuco',37],
	[240,'Pinto',37],
	[241,'Portezuelo',37],
	[242,'Quillón',37],
	[243,'Quirihue',37],
	[244,'Ránquil',37],
	[245,'San Carlos',37],
	[246,'San Fabián',37],
	[247,'San Ignacio',37],
	[248,'San Nicolás',37],
	[249,'Treguaco',37],
	[250,'Yungay',37],
	[251,'Carahue',38],
	[252,'Cholchol',38],
	[253,'Cunco',38],
	[254,'Curarrehue',38],
	[255,'Freire',38],
	[256,'Galvarino',38],
	[257,'Gorbea',38],
	[258,'Lautaro',38],
	[259,'Loncoche',38],
	[260,'Melipeuco',38],
	[261,'Nueva Imperial',38],
	[262,'Padre Las Casas',38],
	[263,'Perquenco',38],
	[264,'Pitrufquén',38],
	[265,'Pucón',38],
	[266,'Saavedra',38],
	[267,'Temuco',38],
	[268,'Teodoro Schmidt',38],
	[269,'Toltén',38],
	[270,'Vilcún',38],
	[271,'Villarrica',38],
	[272,'Angol',39],
	[273,'Collipulli',39],
	[274,'Curacautín',39],
	[275,'Ercilla',39],
	[276,'Lonquimay',39],
	[277,'Los Sauces',39],
	[278,'Lumaco',39],
	[279,'Purén',39],
	[280,'Renaico',39],
	[281,'Traiguén',39],
	[282,'Victoria',39],
	[283,'Corral',40],
	[284,'Lanco',40],
	[285,'Los Lagos',40],
	[286,'Máfil',40],
	[287,'Mariquina',40],
	[288,'Paillaco',40],
	[289,'Panguipulli',40],
	[290,'Valdivia',40],
	[291,'Futrono',41],
	[292,'La Unión',41],
	[293,'Lago Ranco',41],
	[294,'Río Bueno',41],
	[295,'Ancud',42],
	[296,'Castro',42],
	[297,'Chonchi',42],
	[298,'Curaco de Vélez',42],
	[299,'Dalcahue',42],
	[300,'Puqueldón',42],
	[301,'Queilén',42],
	[302,'Quemchi',42],
	[303,'Quellón',42],
	[304,'Quinchao',42],
	[305,'Calbuco',43],
	[306,'Cochamó',43],
	[307,'Fresia',43],
	[308,'Frutillar',43],
	[309,'Llanquihue',43],
	[310,'Los Muermos',43],
	[311,'Maullín',43],
	[312,'Puerto Montt',43],
	[313,'Puerto Varas',43],
	[314,'Osorno',44],
	[315,'Puero Octay',44],
	[316,'Purranque',44],
	[317,'Puyehue',44],
	[318,'Río Negro',44],
	[319,'San Juan de la Costa',44],
	[320,'San Pablo',44],
	[321,'Chaitén',45],
	[322,'Futaleufú',45],
	[323,'Hualaihué',45],
	[324,'Palena',45],
	[325,'Aisén',46],
	[326,'Cisnes',46],
	[327,'Guaitecas',46],
	[328,'Cochrane',47],
	[329,'O\'higgins',47],
	[330,'Tortel',47],
	[331,'Coihaique',48],
	[332,'Lago Verde',48],
	[333,'Chile Chico',49],
	[334,'Río Ibáñez',49],
	[335,'Antártica',50],
	[336,'Cabo de Hornos',50],
	[337,'Laguna Blanca',51],
	[338,'Punta Arenas',51],
	[339,'Río Verde',51],
	[340,'San Gregorio',51],
	[341,'Porvenir',52],
	[342,'Primavera',52],
	[343,'Timaukel',52],
	[344,'Natales',53],
	[345,'Torres del Paine',53]
]

begin
  region = Spree::State.find_by(name: "Tarapacá") #"Región de Tarapacá"
  Spree::State.create(name:"Tarapacá",mda_a: 89900, mda_b: 84900, mda_c: 79900, sda_a: 22900, sda_b: 19900, sda_c: 16900, pai_a: 22900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 1 creada"
  region = Spree::State.find_by(name: "Antofagasta")# "Región de Antofagasta"
  Spree::State.create(name: "Antofagasta", mda_a: 59900, mda_b: 54900, mda_c: 49900, sda_a: 19900, sda_b: 16900, sda_c: 13900, pai_a: 19900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 2 creada"

  region = Spree::State.find_by(name: "Atacama") #"Región de Atacama"
  Spree::State.create(name: "Atacama", mda_a: 89900, mda_b: 84900, mda_c: 79900, sda_a: 22900, sda_b: 19900, sda_c: 16900, pai_a: 22900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 3 creada"
  
  region = Spree::State.find_by(name: "Coquimbo") #"Región de Coquimbo"
  Spree::State.create(name: "Coquimbo", mda_a: 49900, mda_b: 44900, mda_c: 39900, sda_a: 15900, sda_b: 12900, sda_c: 9900, pai_a: 15900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 4 creada"
  
  region = Spree::State.find_by(name: "Valparaíso")#"Región de Valparaíso"
  Spree::State.create(name: "Valparaíso", mda_a: 39900, mda_b: 34900, mda_c: 29900, sda_a: 9900, sda_b: 6900, sda_c: 3900, pai_a: 9900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 5 creada"
  
  region = Spree::State.find_by(name: "Libertador General Bernardo O'Higgins") #"Región del Libertador General Bernardo O’Higgins"
  Spree::State.create(name: "Libertador General Bernardo O'Higgins", mda_a: 49900, mda_b: 44900, mda_c: 39900, sda_a: 9900, sda_b: 5900, sda_c: 3900, pai_a: 9900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 6 creada"
  
  region = Spree::State.find_by(name: "Maule") #"Región del Maule"
  Spree::State.create(name: "Maule", mda_a: 64900, mda_b: 59900, mda_c: 54900, sda_a: 19900, sda_b: 16900, sda_c: 13900, pai_a: 19900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 7 creada"
  
  region = Spree::State.find_by(name: "Bío-Bío") #"Región del Biobío"
  Spree::State.create(name: "Bío-Bío", mda_a: 45900, mda_b: 40900, mda_c: 35900, sda_a: 14900, sda_b: 11900, sda_c: 8900, pai_a: 14900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 8 creada"
  
  region = Spree::State.find_by(name: "Araucanía")# "Región de la Araucanía"
  Spree::State.create(name: "Araucanía", mda_a: 69900, mda_b: 64900, mda_c: 59900, sda_a: 14900, sda_b: 11900, sda_c: 8900, pai_a: 14900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 9 creada"
  
  region = Spree::State.find_by(name: "Los Lagos") #"Región de los Lagos"
  Spree::State.create(name: "Los Lagos" ,mda_a: 64900, mda_b: 59900, mda_c: 54900, sda_a: 14900, sda_b: 11900, sda_c: 8900, pai_a: 14900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 10 creada"
  
  region = Spree::State.find_by(name: "Aisén del General Carlos Ibáñez del Campo") #"Región Aysén"
  Spree::State.create(name: "Aisén del General Carlos Ibáñez del Campo", mda_a: 69900, mda_b: 54900, mda_c: 59900, sda_a: 14900, sda_b: 11900, sda_c: 8900, pai_a: 14900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 11 creada"
  
  region = Spree::State.find_by(name: "Magallanes y Antártica Chilena") #"Región de Magallanes y Antártica Chilena"
  Spree::State.create(name: "Magallanes y Antártica Chilena", mda_a: 69900, mda_b: 64900, mda_c: 59900, sda_a: 14900, sda_b: 11900, sda_c: 8900, pai_a: 14900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 12 creada"
  
  region = Spree::State.find_by(name: "Región Metropolitana de Santiago") #"Región Metropolitana"
  Spree::State.create(name: "Región Metropolitana de Santiago", mda_a: 19900, mda_b: 17900, mda_c: 15900, sda_a: 6900, sda_b: 5900, sda_c: 4900, pai_a: 6900, inst_a: (44900), inst_b: (39900), inst_c: (34900)) if !region
  puts "region 13 creada"
  
  region = Spree::State.find_by(name: "Los Ríos") #"Región de los Ríos"
  Spree::State.create(name: "Los Ríos", mda_a: 49900, mda_b: 44900, mda_c: 39900, sda_a: 14900, sda_b: 11900, sda_c: 8900, pai_a: 14900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 14 creada"
  
  region = Spree::State.find_by(name: "Arica y Parinacota") #"Región de Arica y Parinacota"
  Spree::State.create(name: "Arica y Parinacota", mda_a: 69900, mda_b: 64900, mda_c: 59900, sda_a: 19900, sda_b: 16900, sda_c: 13900, pai_a: 19900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 15 creada"
  
  region = Spree::State.find_by(name: "Ñuble") #"Región del Biobío"
  Spree::State.create(name: "Ñuble", mda_a: 45900, mda_b: 40900, mda_c: 35900, sda_a: 14900, sda_b: 11900, sda_c: 8900, pai_a: 14900, inst_a: (44900 + 49900), inst_b: (39900 + 44900), inst_c: (34900 + 39900)) if !region
  puts "region 16 creada"
  puts "Despachos por Comuna cargados correctamente"
rescue
  puts 'WARNING: Falló la carga de despachos por Region'
end


begin
	comuna_list.each do |id, name, province_id|
	  Comuna.create( id: id, name: name, province_id: province_id )
	end
rescue Exception => e
	puts 'Comunas ya agregadas'
end

begin
	Spree::Product.all.each do |product|
		product.sensitive_name = product.sensitive_name_t
		product.save
	end
rescue Exception => e
	puts 'Productos ya actualizados'
end

begin
	static_pages = [
		{id: 1, name: 'Sobre Miele', slug: 'sobre-miele', editable: false},
		{id: 2, name: 'Noticias y Eventos', slug: 'noticias-y-eventos', editable: false},
		{id: 3, name: 'Garantía y Paquetes de Servicio', slug: 'garantia-y-paquetes-de-servicio', editable: false},
		{id: 4, name: 'Métodos y costos de envío', slug: 'metodos-y-costos-de-envio', editable: false},
		{id: 5, name: 'Aviso Legal', slug: 'aviso-legal', editable: false},
		{id: 6, name: 'Términos y Condiciones', slug: 'terminos-y-condiciones', editable: false},
		{id: 7, name: 'Contáctanos', slug: 'contactanos', editable: false},
		{id: 8, name: 'Miele Experience Center', slug: 'miele-experience-center', editable: false},
		{id: 9, name: 'Políticas de Privacidad', slug: 'privacy-policy', editable: false}
	]
	StaticPage.create(static_pages)
	ActiveRecord::Base.connection.execute("SELECT setval('static_pages_id_seq', (SELECT max(id) FROM static_pages))")
rescue Exception => e
	puts "Páginas estáticas ya actualizadas"
end

begin
	Spree::Role.create(id: 3, name: 'Vendedor')
	puts 'Rol Vendedor creado con éxito.'
rescue Exception => e 
	puts 'Rol Vendedor ya creado!'
end

begin
	VirtualSupport.create(id: 1, name: 'Soporte Virtual', description: 'Descripción', active: false, url: nil)
rescue Exception => e
	
end

begin
	MieleConfig.create(id: 1, title_oportunities: 'Oportunidades', start_oportunities: '01-01-2020', end_oportunities: '01-01-2020')
rescue Exception => e
	puts 'Configuración ya creada!'
end