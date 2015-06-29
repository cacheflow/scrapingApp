// var stringMatcher = function(strs) {
//   return function findMatches(q, cb) {
//     var matches, stringRegex;
 
//     matches = [];
 
//     stringRegex = new RegExp(q, 'i');
 
//     $.each(strs, function(i, str) {
//       if (stringRegex.test(str)) {
//         matches.push({ value: str });
//       }
//     });
 
//     cb(matches);
//   };
// };
 
// var construction = ["Amazone", 
// "Ammann", "Atlas", "Atlas", "Copco", 
// "Atlet", "Bobcat", "Bomag", "BT", 
// "Case", "Case", "IH", "Caterpillar", 
// "Citron", "CLAAS", "Cummins", "Daewoo", 
// "DAF", "Demag", "Deutz", "Deutz-fahr", 
// "DFAC", "Ditch", "Witch", "Doosan", 
// "Dynapac", "Fendt", "Fiat", "Fiat-Hitachi", 
// "Ford", "Freightliner", "Genie", "Grove", 
// "Hamm", "Hardi", "Haulotte", "Hitachi", 
// "Horsch", "Hyster", "Hyundai", "Ingersoll", 
// "Rand", "International", "Isuzu", "Iveco", 
// "JCB", "JF", "JLG", "John", "Deere", 
// "Jungheinrich", "Kalmar", "Kato", "Kenworth", 
// "Kobelco", "Komatsu", "Kongskilde", "Krone", 
// "Kubota", "Kuhn", "Kverneland", "Lemken", 
// "Liebherr", "Liming", "Linde", "MAN", 
// "Manitou", "Massey", "Ferguson", "Mercedes-Benz", 
// "Merlo", "Michelin", "Mitsubishi", "New", "Holland", 
// "Nissan", "O&K", "Peterbilt", "Peugeot", "Pioneer", 
// "Potain", "pottinger", "Renault", "Scania", "Schmitz", 
// "Schmitz", "Cargobull", "Skyjack", "Stiga", "Still", 
// "Tadano", "Takeuchi", "TCM", "Terex", "Timberjack", 
// "Toyota", "Unimog", "Vderstad", "Valmet", "Valtra", 
// "Vermeer", "Vicon", "Volkswagen", "Volvo", "Wacker", 
// "Yale", "Yanmar", "ZF"]
 
// $(document).ready(function(){
//   alert("Hello Lex");
// });

$(document).ready(
  $('#search_button').click(function(){
    $('.search_form').hide();
    $('#bear').show();
  })
);  
// $(document).ready(function(){
//   ('#search').typeahead({
//   hint: true,
//   highlight: true,
//   spellcheck: true,
//   minLength: 1,
//   name: 'construction',
//   displayKey: 'value',
//   source: stringMatcher(construction)
//   })   
// });
