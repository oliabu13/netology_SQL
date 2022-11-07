--1
SELECT g.name genres, COUNT(artist_id) count_artists FROM genre_artist ga 
JOIN genres g ON a.genre_id = g.id
GROUP BY genres
ORDER BY count_artists DESC;

--2
SELECT a.name album_name, COUNT (t.name) count_tracks FROM tracks t
JOIN album a ON t.album_id = a.id
WHERE EXTRACT (YEAR FROM a.created) BETWEEN 2019 AND 2020
GROUP BY album_name
ORDER BY count_tracks DESC;

--3
SELECT a.name album_name, ROUND(AVG(t.duration), 2) avg_duration FROM tracks t 
JOIN album a ON t.album_id = a.id
GROUP BY album_name
ORDER BY avg_duration DESC;

--4
SELECT DISTINCT ar.name FROM album_artist aa 
JOIN albums al ON aa.album_id = al.id 
JOIN artists ar ON aa.artist_id = ar.id
WHERE EXTRACT (YEAR FROM al.created) NOT IN (2020);

--5
SELECT DISTINCT c.name collection_name FROM collection_track ct 
JOIN tracks t ON ct.track_id = t.id 
JOIN album al ON t.album_id = al.id
JOIN album_artist aa ON al.id = aa.album_id
JOIN artist ar ON aa.artist_id = ar.id
JOIN collection c ON ct.collection_id = c.id
WHERE ar.name = 'NF';

--6
SELECT al.name al_name, ar.name ar_name, COUNT(g.name) count_gener FROM genre_artist ga
JOIN artist ar ON ga.artist_id = ar.id
JOIN album_artist aa ON ar.id = aa.artist_id
JOIN album al ON aa.album_id = al.id
JOIN genres g ON ga.genre_id = g.id
GROUP BY al.name, ar.name
HAVING COUNT(g.name) > 1;

--7
SELECT name FROM tracks t
LEFT JOIN collection_track ct ON ct.trak_id = t.id
WHERE ct.collection_id IS NULL; 

--8
SELECT ar.name, t.duration FROM tracks t 
JOIN album_artist aa ON aa.album_id = t.album_id
JOIN artist ar ON aa.artist_id = ar.id
WHERE t.duration = (SELECT min(duration) FROM tracks);

--9
SELECT a.name album_name, COUNT(album_id) FROM tracks t 
JOIN album a ON a.id = t.album_id
GROUP BY al.name
HAVING COUNT(album_id) = 
	(SELECT count(album_id) count_album FROM tracks
	GROUP BY album_id
	ORDER BY count_album LIMIT 1);