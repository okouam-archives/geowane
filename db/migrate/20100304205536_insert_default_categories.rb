# coding: utf-8

class InsertDefaultCategories < ActiveRecord::Migration

  def self.up
    Category.create!(:code => '0x100', :french => 'Grande ville, plus de 10M', :icon => "bigcity.png", :visible => false, :english => 'Large city - between 5M and 10M')

     execute %{
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2', 'Grand ville, 5-10 M', 'Large city - between 5M and 10M', 'point', 'bigcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x3', 'Grande ville, 2-5 M', 'Large city - between 2M and 5M', 'point', 'bigcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x4', 'Grande ville, 1-2 M', 'Large city - between 1M and 2M', 'point', 'bigcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x5', 'Ville moyenne, 0.5-1M', 'Medium city - between 500K and 1M', 'point', 'bigcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x6', 'Ville moyenne, 200-500K', 'Medium city - between 200K and 500K', 'point', 'bigcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xb', 'Petite ville/commune, 5-10K', 'Small city or town - between 5K and 10K', 'point', 'smallcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xe', 'Hameau, 500-1K', 'Settlement - between 500 and 1K', 'point', 'smallcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x9', 'Petite ville, 20-50K', 'Small city - between 20K and 50K', 'point', 'smallcity.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a07', 'Restauration rapide', 'Fast food', 'point', 'fastfood.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2b01', 'Hôtel/Motel', 'Hotel or motel', 'point', 'hotel.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c0b', 'Lieu de culte', 'Place of workship', 'point', 'church.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a', 'Restaurant', 'Dining', 'point', 'restaurant.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a02', 'Restaurant (Asiatique)', 'Dining - Asian', 'point', 'restaurantkorean.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a05', 'Restaurant (Deli/Boulangerie)', 'Dining - Deli or bakery', 'point', 'restaurantmediterranean.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a06', 'Restaurant (International)', 'Dining - International', 'point', 'restaurant.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a08', 'Restaurant (Italien)', 'Dining - Italian', 'point', 'restaurantitalian.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a0f', 'Restaurant (Français)', 'Dining - French', 'point', 'restaurant.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c01', 'Loisirs/Parc à thème', 'Amusement or theme park', 'point', 'restaurant.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c02', 'Musée/Histoire', 'Museum or historical setting', 'point', 'monument.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c03', 'Bibliotheque', 'Library', 'point', 'library.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c04', 'Point de repere', 'Landmark', 'point', 'modernmonument.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c05', 'Ecole', 'School', 'point', 'crossingguard.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c06', 'Parc/Jardin', 'Park or garden', 'point', 'park.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c07', 'Zoo/Aquarium', 'Zoo or aquarium', 'point', 'aquarium.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c08', 'Arène/Piste', 'Arena or track', 'point', 'restaurant.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2c09', 'Hall/auditorium', 'Hall or auditorium', 'point', 'conference.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2d01', 'Théâtre', 'Live theatre', 'point', 'theater.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2d02', 'Bar ou boite de nuit', 'Bar or nightclub', 'point', 'club.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2d03', 'Cinéma', 'Cinema', 'point', 'cinema.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2d04', 'Casino', 'Casino', 'point', 'casino.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2d05', 'Golf', 'Golf course', 'point', 'golf.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2d06', 'Stations balnéaires', 'Skiing center or resort', 'point', 'skiing.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2d0a', 'Sport, Fitness', 'Sports or fitness center', 'point', 'fitnesscenter.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e01', 'Grand magasin', 'Department store', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e02', 'Epicerie', 'Grocery store', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e03', 'General merchandiser', 'General merchandiser', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e04', 'Centre commercial', 'Shopping center', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e05', 'Pharmacie', 'Pharmacy', 'point', 'drugs.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e06', 'Boutique de quartier', 'Convenience store', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e07', 'Vêtements', 'Apparel', 'point', 'clothes.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e08', 'Maison et jardin', 'House and garden', 'point', 'home.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e09', 'Ameublement de maison', 'Home furnishing', 'point', 'home.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e0a', 'Chaines spécialisées', 'Speciality retail', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f01', 'Carburant auto', 'Auto fuel', 'point', 'gazstation.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f02', 'Location de voiture', 'Auto rental', 'point', 'car.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f03', 'Réparation de voiture', 'Auto repair', 'point', 'car.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x6405', 'Immeuble civil', 'Civil building', 'point', 'justice.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f06', 'Banque / Guichet automatique', 'Bank or ATM', 'point', 'bank.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f05', 'Poste', 'Post office', 'point', 'postal.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x6403', 'Cimetière', 'Cemetary', 'point', 'cemetary.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x3001', 'Station de police', 'Police station', 'point', 'police.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x3002', 'Hôpital', 'Hospital', 'point', 'hospital.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f07', 'Pièces détachées', 'Dealer or auto parts', 'point', 'car.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x45', 'Restaurant', 'Restaurant', 'point', 'restaurant.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f04', 'Transport aérien', 'Air transportation', 'point', 'airport.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f08', 'Transport terrestre', 'Ground transportation', 'point', 'train.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f09', 'Marina/Réparation de bateau', 'Marina or boat repair', 'point', 'sailboat.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f0b', 'Parking', 'Parking', 'point', 'parking.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f0c', 'Secteur de repos ou info touristes', 'Rest area or tourist info ', 'point', 'info.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f10', 'Services à la personne', 'Personal services', 'point', 'hairsalon.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f11', 'Business', 'Business service', 'point', 'company.png', false);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f15', 'Service public', 'Public utilities', 'point', 'windturbine.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f17', 'Service transit', 'Transit service', 'point', 'subway.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x3007', 'Bâtiment public', 'Government office', 'point', 'findjob.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x3008', 'Sapeurs pompiers', 'Fire department', 'point', 'firemen.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x5903', 'Petit aéroport', 'Small airport', 'point', 'airport.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x6402', 'Immeuble', 'Building', 'point', 'conference.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x640b', 'Base militaire', 'Military base', 'point', 'military.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf701', 'Marché', 'Market', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf801', 'Cabinet dentaire', 'Dental Clinic', 'point', 'drugs.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2a0a', 'Chaines spécialisées', 'Specialty retail', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf606', 'Atelier de couture', 'Dressmaking atelier', 'point', 'supermarket.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf602', 'Salon de coiffure', 'Hairdressing Salon', 'point', 'hairsalon.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x4400', 'Station essence', 'Gas Station', 'point', 'gazstation.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf001', 'Gare de bus', 'Bus station', 'point', 'bus.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf006', 'Gare de train', 'Railway station', 'point', 'train.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf103', 'Eglise protestante', 'Protestant church', 'point', 'cathedral.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf102', 'Eglise catholique', 'Catholic church', 'point', 'church.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf104', 'Mosquée', 'Mosque', 'point', 'mosque.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf101', 'Eglise orthodoxe', 'Orthodox church', 'point', 'monastery.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf505', 'Ecole spécialisée', 'Specialized school', 'point', 'school.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf504', 'Université', 'University/College', 'point', 'university.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf613', 'Agence de voyage', 'Travel agency', 'point', 'airport.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf706', 'Appareils mobiles', 'Mobile devices', 'point', 'wifi.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf616', 'Cybercafé', 'Cybercafe', 'point', 'computer.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x640f', 'Poste', 'Post office', 'point', 'postal.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f13', 'Service de réparation', 'Repair service', 'point', 'tools.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f12', 'Communication service', 'Communication service', 'point', 'audio.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf002', 'Arrêt de bus', 'Bus stop', 'point', 'bus.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf802', 'Clinique vétérinaire', 'Veterinary clinic', 'point', 'vet.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf605', 'Studio photo', 'Photographer''s studio', 'point', 'photo.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0xf60e', 'Assurance', 'Insurance', 'point', 'photo.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2f', 'Services', 'Services', 'point', 'photo.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x44', 'Station essence', 'Gas station', 'point', 'photo.png', true);
        INSERT INTO categories (code, french, english, classification, icon, visible) VALUES ('0x2e', 'Shopping', 'Shopping', 'point', 'photo.png', true);
        UPDATE categories SET numeric_code = to_dec(substring(code from 3));
  }
  end
  
end                 
