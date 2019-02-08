from nltk.corpus import brown
brown.categories()
# ['adventure', 'belles_lettres', 'editorial', 'fiction', 'government', 'hobbies', 'humor', 'learned', 'lore', 'mystery', 'news', 'religion', 'reviews', 'romance', 'science_fiction']
fiction = brown.words(categories='fiction')
a= [a for a in fiction if len(a)==5]
b=list(set(a))
#len(b) = 1373
