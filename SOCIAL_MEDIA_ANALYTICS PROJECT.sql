/* SOCIAL MEDIA ANALYTICS */

CREATE DATABASE SOCIAL_MEDIA;
USE SOCIAL_MEDIA;

CREATE TABLE Users
(
user_id int primary key auto_increment,
username varchar(25) not null unique,
name varchar(25),
location varchar(50)
);

desc Users;

INSERT INTO Users VALUES
(1,'alice123','Alice Smith','New Work'),
(2,'bob456','Bob Jones','Los Angeles'),
(3,'charlie789','Charlie Brown','Chicago'); 

SELECT * FROM Users;

CREATE TABLE Posts
(
post_id int primary key auto_increment,
user_id int not null,
content varchar(100),
timestamp TIMESTAMP default current_timestamp,
FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

DESC Posts;

INSERT INTO Posts Values
(100, 1, 'Just finished reading a great book!', '2024-05-20'),
(101, 2, 'What are you guys up to this weekend?', '2024-05-21'),
(102, 3, 'Happy birthday to me!', '2024-05-25');

SELECT * FROM Posts;

CREATE TABLE Likes
(
Like_id int primary key auto_increment,
post_id int not null,
user_id int not null,
timestamp TIMESTAMP default current_timestamp,
FOREIGN KEY (post_id) REFERENCES Posts(post_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

DESC Likes;

INSERT INTO Likes VALUES
(1, 100, 2, '2024-05-20'),
(2, 100, 3, '2024-05-21'),
(3, 101, 1, '2024-05-21'),
(4, 102, 1, '2024-05-25');

SELECT * FROM Likes;

CREATE TABLE Comments
(
comment_id int primary key auto_increment,
post_id int not null,
user_id int not null,
content varchar(100),
timestamp TIMESTAMP default current_timestamp,
FOREIGN KEY (post_id) REFERENCES Posts(post_id),
FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

DESC Comments;

INSERT INTO Comments VALUES 
(1, 100, 3, 'This book sounds interesting!', '2024-05-21'),
(2, 101, 2, 'Let\'s go hiking!', '2024-05-22'),
(3, 102, 1, 'Happy birthday!', '2024-05-25');

SELECT * FROM Comments;

/* 1.MOST ACTIVE USERS:
Find the users who are most active based on their likes, comments, and posts.
*/

SELECT u.user_id, u.username,
    COUNT(DISTINCT p.post_id) AS post_count,
    COUNT(DISTINCT l.like_id) AS like_count,
    COUNT(DISTINCT c.comment_id) AS comment_count,
    (COUNT(DISTINCT p.post_id) + COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id)) AS total_activity
FROM Users u
LEFT JOIN Posts p ON u.user_id = p.user_id
LEFT JOIN Likes l ON u.user_id = l.user_id
LEFT JOIN Comments c ON u.user_id = c.user_id
GROUP BY 
    u.user_id, u.username
ORDER BY 
    total_activity DESC;
    
/*Explanation:
   We aggregate posts, likes, and comments for each user.
   LEFT JOIN ensures we include users with no activity.
   Total_activity combines posts, likes, and comments for ranking.
   Results are sorted by total_activity in descending order.*/

/* 2.MOST POPULAR POSTS BY LIKES:
Identify posts with the highest number of likes.
*/

SELECT 
    p.post_id,
    p.content,
    u.username AS author,
    COUNT(l.like_id) AS like_count
FROM 
    Posts p
JOIN Users u ON p.user_id = u.user_id
LEFT JOIN Likes l ON p.post_id = l.post_id
GROUP BY 
    p.post_id, p.content, u.username
ORDER BY 
    like_count DESC;
    
/*Explanation:
    Count the number of likes per post using COUNT(l.like_id).
    JOIN the Users table to include post author details.
    Sort results by like_count in descending order to identify popular posts.*/
    
/* 3.TOP COMMENTING USERS:
Find users who comment the most.
*/

SELECT 
    u.user_id,
    u.username,
    COUNT(c.comment_id) AS comment_count
FROM 
    Users u
LEFT JOIN Comments c ON u.user_id = c.user_id
GROUP BY 
    u.user_id, u.username
ORDER BY 
    comment_count DESC;
    
/*Explanation:
    Count comments for each user using COUNT(c.comment_id).
	LEFT JOIN ensures users without comments are included.
    Sort results by comment_count to highlight top commenters.*/
    
/* 4.USERS ENGAGEMENT BY LOCATION:
Measure engagement (posts, likes, comments) grouped by user location.
*/

SELECT 
    u.location,
    COUNT(DISTINCT p.post_id) AS total_posts,
    COUNT(DISTINCT l.like_id) AS total_likes,
    COUNT(DISTINCT c.comment_id) AS total_comments,
    (COUNT(DISTINCT p.post_id) + COUNT(DISTINCT l.like_id) + COUNT(DISTINCT c.comment_id)) AS total_engagement
FROM 
    Users u
LEFT JOIN Posts p ON u.user_id = p.user_id
LEFT JOIN Likes l ON u.user_id = l.user_id
LEFT JOIN Comments c ON u.user_id = c.user_id
GROUP BY 
    u.location
ORDER BY 
    total_engagement DESC;
    
/*Explanation:
    Engagement is calculated by summing posts, likes, and comments for each location.
    Group results by u.location.
    Sort by total engagement to identify the most active locations.*/
    
/* 5.AVERAGE DAILY POSTS:
Calculate the average number of posts created daily.
*/

SELECT 
    DATE(p.timestamp) AS post_date,
    COUNT(p.post_id) AS daily_posts,
    AVG(COUNT(p.post_id)) OVER () AS avg_daily_posts
FROM 
    Posts p
GROUP BY 
    DATE(p.timestamp);
    
/*Explanation:
    Group posts by date using DATE(p.timestamp).
	Use COUNT(p.post_id) to count daily posts.
    Compute the overall average using the AVG window function.*/
    
/* 6.MOST ACTIVE DAYS FOR POSTING:
Identify the days with the highest number of posts.
*/

SELECT 
    DATE(p.timestamp) AS post_date,
    COUNT(p.post_id) AS post_count
FROM 
    Posts p
GROUP BY 
    DATE(p.timestamp)
ORDER BY 
    post_count DESC;

/*Explanation:
    Group posts by date to count posts per day.
    Sort by post_count in descending order.*/
    
    




