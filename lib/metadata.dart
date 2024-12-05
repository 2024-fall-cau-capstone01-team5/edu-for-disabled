/* 현재 준비된 시나리오들의 정보 */

final Map<String, String> imageUrl = {
  '편의점': 'assets/thumbnails/store.webp',
  '공원': 'assets/thumbnails/park.webp',
  '복지관': 'assets/thumbnails/disability_center.webp',
  '외출 준비': 'assets/thumbnails/ready_to_go_outside.webp',
  '베란다': 'assets/thumbnails/terras.webp',
  '주방': 'assets/thumbnails/kitchen.webp',
  '낯선 사람': 'assets/thumbnails/bad_attraction.webp',
  '길을 잃었을 때': 'assets/thumbnails/missing.webp',
  '땅이 흔들릴 때': 'assets/thumbnails/earthquake.webp',
};

final List<List<String>> images = [
  ['assets/thumbnails/store.webp', 'assets/thumbnails/park.webp', 'assets/thumbnails/disability_center.webp'],
  ['assets/thumbnails/ready_to_go_outside.webp', 'assets/thumbnails/terras.webp', 'assets/thumbnails/kitchen.webp'],
  ['assets/thumbnails/bad_attraction.webp', 'assets/thumbnails/missing.webp', 'assets/thumbnails/earthquake.webp']
];

final List<String> category = ['외부활동', '가정활동', '도움요청'];

final List<List<String>> labels = [
  ['편의점', '공원', '복지관'],
  ['외출 준비', '베란다', '주방'],
  ['낯선 사람', '길을 잃었을 때', '땅이 흔들릴 때']
];