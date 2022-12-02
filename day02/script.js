

lines = p => require('fs').readFileSync(__dirname+p, 'utf-8').split(/\r?\n/)
shape = x => ({ A: 1, X: 1, B: 2, Y: 2, C: 3, Z: 3 }[x])
won = x => ({ 1: 3, 2: 1, 3: 2 }[x])
score = (a, b) => b + (a == b ? 3 : won(b) == a ? 6 : 0)
play = (a, b) => b == 2 ? a : b == 1 ? won(a) : won(won(a))
sum = l => l.reduce((r, x) => r+x, 0);

data = lines('/input.txt').filter(Boolean).map(l => l.split(' ').map(shape))
star1 = sum(data.map(([a,b]) => score(a, b)))
star2 = sum(data.map(([a,b]) => score(a, play(a,b))))

console.log(star1, star2);
