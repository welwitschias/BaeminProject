DROP TABLE bm_food CASCADE CONSTRAINTS;
DROP TABLE bm_food_option CASCADE CONSTRAINTS;
DROP TABLE bm_gift_card CASCADE CONSTRAINTS;
DROP TABLE bm_likes CASCADE CONSTRAINTS;
DROP TABLE bm_order_detail_non_user CASCADE CONSTRAINTS;
DROP TABLE bm_order_detail_user CASCADE CONSTRAINTS;
DROP TABLE bm_order_non_user CASCADE CONSTRAINTS;
DROP TABLE bm_order_user CASCADE CONSTRAINTS;
DROP TABLE bm_point CASCADE CONSTRAINTS;
DROP TABLE bm_review CASCADE CONSTRAINTS;
DROP TABLE bm_store CASCADE CONSTRAINTS;
DROP TABLE bm_user CASCADE CONSTRAINTS;
DROP TABLE bm_my_store CASCADE CONSTRAINTS;
DROP SEQUENCE user_id_seq;
DROP SEQUENCE store_id_seq;
DROP SEQUENCE food_id_seq;
DROP SEQUENCE option_id_seq;


-- 유저 테이블
CREATE TABLE bm_user (
    id       NUMBER PRIMARY KEY,
    username VARCHAR2(100) NOT NULL,
    password VARCHAR2(100) NOT NULL,
    email    VARCHAR2(50),
    nickname VARCHAR2(50),
    point    NUMBER DEFAULT 0,
    phone    VARCHAR2(20),
    rating   VARCHAR2(50) DEFAULT 0,
    role     VARCHAR2(20) DEFAULT 'ROLE_USER'
);

-- 유저 번호 자동증가    
CREATE SEQUENCE user_id_seq INCREMENT BY 1 START WITH 1 MINVALUE 1 MAXVALUE 99999999999 NOCYCLE NOCACHE NOORDER;





-- 가게 테이블
CREATE TABLE bm_store (
    id             NUMBER PRIMARY KEY,
    category       NUMBER NOT NULL,
    store_name     VARCHAR2(100) NOT NULL,
    store_address1 VARCHAR2(200) NOT NULL,
    store_address2 VARCHAR2(200) NOT NULL,
    store_address3 VARCHAR2(200),
    store_phone    VARCHAR2(20) NOT NULL,
    store_img      VARCHAR2(200),
    store_thumb    VARCHAR2(200),
    opening_time   NUMBER DEFAULT 0,
    closing_time   NUMBER DEFAULT 0,
    min_delivery   NUMBER DEFAULT 0,
    delivery_time  NUMBER DEFAULT 0,
    delivery_tip   NUMBER DEFAULT 0,
    store_des      VARCHAR2(1000) DEFAULT '가게소개가 없습니다'
);

-- 가게 번호 자동증가
CREATE SEQUENCE store_id_seq INCREMENT BY 1 START WITH 1 MINVALUE 1 MAXVALUE 99999999999 NOCYCLE NOCACHE NOORDER;





-- 음식 테이블
CREATE TABLE bm_food (
    id         NUMBER PRIMARY KEY,
    store_id   NUMBER NOT NULL,
    food_name  VARCHAR2(100) NOT NULL,
    food_price NUMBER NOT NULL,
    food_dec   VARCHAR2(200),
    food_img   VARCHAR2(200),
    food_thumb VARCHAR2(200)
);

-- 음식 번호 자동증가
CREATE SEQUENCE food_id_seq INCREMENT BY 1 START WITH 1 MINVALUE 1 MAXVALUE 99999999999 NOCYCLE NOCACHE NOORDER;

-- 외래키 지정
ALTER TABLE bm_food
    ADD CONSTRAINT food FOREIGN KEY ( store_id )
        REFERENCES bm_store ( id )
            ON DELETE CASCADE;





-- 음식 추가옵션 테이블
CREATE TABLE bm_food_option (
    id           NUMBER PRIMARY KEY,
    food_id      NUMBER NOT NULL,
    option_name  VARCHAR2(100) NOT NULL,
    option_price NUMBER NOT NULL
);

-- 음식 추가옵션 자동증가
CREATE SEQUENCE option_id_seq INCREMENT BY 1 START WITH 1 MINVALUE 1 MAXVALUE 99999999999 NOCYCLE NOCACHE NOORDER;

-- 외래키 지정
ALTER TABLE bm_food_option
    ADD CONSTRAINT food_option FOREIGN KEY ( food_id )
        REFERENCES bm_food ( id )
            ON DELETE CASCADE;





-- 회원 주문정보 테이블
CREATE TABLE bm_order_user (
    order_num         NUMBER PRIMARY KEY,
    store_id          NUMBER NOT NULL,
    user_id           NUMBER NOT NULL,
    order_date        TIMESTAMP DEFAULT sysdate,
    pay_method        VARCHAR2(30),
    delivery_status   VARCHAR2(50) DEFAULT '주문접수 대기 중',
    phone             VARCHAR2(20) NOT NULL,
    delivery_address1 NUMBER NOT NULL,
    delivery_address2 VARCHAR2(200) NOT NULL,
    delivery_address3 VARCHAR2(200),
    total_price       NUMBER NOT NULL,
    used_point        NUMBER DEFAULT 0,
    request           VARCHAR2(2000),
    imp_uid           VARCHAR2(30) -- 아임포트 결제번호
);





-- 회원 상세주문정보 테이블
CREATE TABLE bm_order_detail_user (
    order_num NUMBER,
    food_info VARCHAR2(2000)
);

-- 외래키 지정
ALTER TABLE bm_order_detail_user
    ADD CONSTRAINT order_detail_user FOREIGN KEY ( order_num )
        REFERENCES bm_order_user ( order_num )
            ON DELETE CASCADE;





-- 비회원 주문정보 테이블 (회원/비회원 union all 하기위해 user_id 컬럼 추가)
CREATE TABLE bm_order_non_user (
    order_num         NUMBER PRIMARY KEY,
    store_id          NUMBER NOT NULL,
    user_id           NUMBER NOT NULL,
    order_date        TIMESTAMP DEFAULT sysdate,
    pay_method        VARCHAR2(30),
    delivery_status   VARCHAR2(50) DEFAULT '주문접수 대기 중',
    phone             VARCHAR2(20) NOT NULL,
    delivery_address1 NUMBER NOT NULL,
    delivery_address2 VARCHAR2(200) NOT NULL,
    delivery_address3 VARCHAR2(200),
    total_price       NUMBER NOT NULL,
    used_point        NUMBER DEFAULT 0,
    request           VARCHAR2(2000),
    imp_uid           VARCHAR2(30) -- 아임포트 결제번호
);





-- 비회원 상세주문정보 테이블
CREATE TABLE bm_order_detail_non_user (
    order_num NUMBER,
    food_info VARCHAR2(2000)
);

-- 외래키 지정
ALTER TABLE bm_order_detail_non_user
    ADD CONSTRAINT order_detail_non_user FOREIGN KEY ( order_num )
        REFERENCES bm_order_non_user ( order_num )
            ON DELETE CASCADE;





-- 포인트 테이블
CREATE TABLE bm_point (
    user_id   NUMBER,
    used_date TIMESTAMP DEFAULT sysdate,
    info      VARCHAR2(100) NOT NULL,
    point     NUMBER NOT NULL
);

-- 외래키 지정
ALTER TABLE bm_point
    ADD CONSTRAINT point FOREIGN KEY ( user_id )
        REFERENCES bm_user ( id )
            ON DELETE CASCADE;





-- 리뷰 테이블
CREATE TABLE bm_review (
    order_num      NUMBER PRIMARY KEY,
    store_id       NUMBER NOT NULL,
    review_content VARCHAR2(3000) NOT NULL,
    boss_comment   VARCHAR2(3000),
    regi_date      TIMESTAMP DEFAULT sysdate,
    user_id        NUMBER NOT NULL,
    score          NUMBER NOT NULL,
    review_img     VARCHAR2(200)
);

-- 외래키 지정
ALTER TABLE bm_review
    ADD CONSTRAINT review FOREIGN KEY ( order_num )
        REFERENCES bm_order_user ( order_num )
            ON DELETE CASCADE;





-- 찜하기 테이블
CREATE TABLE bm_likes (
    user_id    NUMBER,
    store_id   NUMBER,
    likes_date TIMESTAMP DEFAULT sysdate
);

-- 외래키 지정
ALTER TABLE bm_likes
    ADD CONSTRAINT likes_user_id FOREIGN KEY ( user_id )
        REFERENCES bm_user ( id )
            ON DELETE CASCADE;

ALTER TABLE bm_likes
    ADD CONSTRAINT likes_store_id FOREIGN KEY ( store_id )
        REFERENCES bm_store ( id )
            ON DELETE CASCADE;





--관리자용 가게 테이블
CREATE TABLE bm_my_store (
    user_id  NUMBER,
    store_id NUMBER
);

--외래키 지정
ALTER TABLE bm_my_store
    ADD CONSTRAINT my_store_u FOREIGN KEY ( user_id )
        REFERENCES bm_user ( id )
            ON DELETE CASCADE;

ALTER TABLE bm_my_store
    ADD CONSTRAINT bm_store_s FOREIGN KEY ( store_id )
        REFERENCES bm_store ( id )
            ON DELETE CASCADE;



--피자(100)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 100, '도미노피자 해운대점', '48102', '부산광역시 해운대구 해운대로 793', '부산자생한방병원 상가 108호',
            '0517027080', '\img\domino_logo.png', '\img\domino_logo.png', 8, 23, 27000, 30, 1000, '도미노피자 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 100, '피자헛 신해운대점', '48110', '부산광역시 해운대구 좌동순환로 308', '송강빌딩',
            '0517046862', '\img\pizzahut_logo.png', '\img\pizzahut_logo.png', 8, 23, 33000, 40, 2000, '피자헛 신해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 100, '미스터피자 해운대점', '48110', '부산광역시 해운대구 세실로 48', '해운대삼정코아주상복합 2-3호',
            '0517032567', '\img\mrpizza_logo.jpg', '\img\mrpizza_logo.jpg', 8, 23, 35000, 40, 3000, '미스터피자 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 100, '파파존스 해운대점', '48091', '부산광역시 해운대구 해운대해변로 163', '현대베네시티 상가동 110호',
            '0517472305', '\img\papajohns_logo.jpg', '\img\papajohns_logo.jpg', 8, 23, 25000, 40, 2500, '파파존스 해운대점입니다.');
            
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 1, '포테이토', '27900', '도미노피자 No.1 레전드',
            '\img\domino_potato.jpg', '\img\domino_potato.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 1, '슈퍼디럭스', '28900', '누구나 사랑하는 베이직 피자',
            '\img\domino_superd.jpg', '\img\domino_superd.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 1, '와일드 와일드 웨스트 스테이크', '33900', '카우보이들이 즐겨먹던 정통 그릴드 비프 스테이크의 재현',
            '\img\domino_wildbeef.jpg', '\img\domino_wildbeef.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 1, '블랙타이거 슈림프', '36900', '바다와 육지의 대왕이 하나로',
            '\img\domino_blacktiger.jpg', '\img\domino_blacktiger.jpg');
    
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 2, '돈마호크', '35900', '돈마호크 180g과 리코타 치즈의 환상 케미',
            '\img\pizzahut_donma.png', '\img\pizzahut_donma.png');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 2, '케이준 더블쉬림프', '35900', '통새우 30마리를 가득 채운 리얼 프리미엄!',
            '\img\pizzahut_doubleshrimp.png', '\img\pizzahut_doubleshrimp.png');    
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 2, '립스테이크', '35900', '180g 갈비맛 스테이크가 통째로',
            '\img\pizzahut_lipsteak.png', '\img\pizzahut_lipsteak.png');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 2, '레몬크림쉬림프', '35900', '싱싱한 레몬크림새우가 가득한 시즌 한정판 피자!',
            '\img\pizzahut_lemoncream.png', '\img\pizzahut_lemoncream.png');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 3, '쉬림프 골드', '36900', '미스터피자하면 쉬림프 골드! 미피의 BEST OF THE BEST!',
            '\img\mrpizza_shrimpgold.jpg', '\img\mrpizza_shrimpgold.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 3, '포테이토 골드', '35900', '고소한 감자와 베이컨의 맛있는 황금밸런스',
            '\img\mrpizza_potatogold.jpg', '\img\mrpizza_potatogold.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 3, '미스터트리오', '37900', '30주년 기념 치블스, 새우천왕, 포테이토골드 3종을 한 판에!',
            '\img\mrpizza_trio.jpg', '\img\mrpizza_trio.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 3, '하프앤하프', '36900', '쉬림프골드와 포테이토골드의 황금콜라보',
            '\img\mrpizza_half.jpg', '\img\mrpizza_half.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 4, '프리미엄 직화불고기', '34900', '정통 직화 불고기와 신선한 야채, 남녀노소 누구나 좋아하는 스테디셀러 피자',
            '\img\papajohns_premiumbulgogi.png', '\img\papajohns_premiumbulgogi.png');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 4, '가든 스페셜', '26500', '자연 그대로의 토마토 소스 위에 신선한 야채가 어우러져 상큼한 풍미가 일품인 웰빙 피자',
            '\img\papajohns_gardenspecial.png', '\img\papajohns_gardenspecial.png');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 4, '갈릭 페퍼 스테이크', '38900', '두툼한 그릴드 비프와 쫄깃한 스트링 치즈, 갈릭 후레이크가 어우러진 프리미엄 스테이크 피자',
            '\img\papajohns_garlicpepper.png', '\img\papajohns_garlicpepper.png');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 4, '존스 페이버릿', '34900', '이탈리안 소시지, 페퍼로니와 6종의 치즈가 만들어 내는 진한 풍미의 피자',
            '\img\papajohns_favorite.png', '\img\papajohns_favorite.png');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 1, '슈퍼시드 함유 도우로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 1, '오리지널 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 1, '오리지널 도우(더블 치즈엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 1, '나폴리 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 1, '마요네즈 30g 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 1, '베이컨 8개/24g 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 1, '도미노치즈 100g 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 2, '슈퍼시드 함유 도우로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 2, '오리지널 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 2, '오리지널 도우(더블 치즈엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 2, '나폴리 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 2, '페퍼로니 8개/20g 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 2, '올리브 20g 추가', 300);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 2, '도미노치즈 100g 추가', 3000);
 
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 3, '슈퍼시드 함유 도우로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 3, '오리지널 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 3, '오리지널 도우(더블 치즈엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 3, '나폴리 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 3, '도미노치즈 100g 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 3, '파인애플 8개/40g 추가', 300);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 3, '올리브 20g 추가', 300);
    
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 4, '슈퍼시드 함유 도우로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 4, '오리지널 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 4, '오리지널 도우(더블 치즈엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 4, '나폴리 도우(트리플 치즈 버스트 엣지)로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 4, '도미노치즈 100g 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 4, '파인애플 8개/40g 추가', 300);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 4, '올리브 20g 추가', 300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '에크타르트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '콘치즈포켓 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '골드바이트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '리치골드 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '모짜렐라 치즈 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '체다 치즈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '소시지 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 5, '통새우 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '에크타르트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '콘치즈포켓 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '골드바이트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '리치골드 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '모짜렐라 치즈 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '통새우 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '베이컨 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 6, '블랙 올리브 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '에크타르트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '콘치즈포켓 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '골드바이트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '리치골드 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '모짜렐라 치즈 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '체다 치즈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '소시지 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 7, '통새우 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '에크타르트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '콘치즈포켓 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '골드바이트 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '리치골드 라지로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '모짜렐라 치즈 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '체다 치즈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '소시지 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 8, '통새우 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 9, '골드 엣지로 변경', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 9, '크림치즈 엣지로 변경', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 9, '치즈캡 엣지로 변경', 4500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 9, '에그타르트 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 10, '골드 엣지로 변경', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 10, '크림치즈 엣지로 변경', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 10, '에그타르트 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 11, '골드 엣지로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 11, '크림치즈 엣지로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 11, '치즈캡 엣지로 변경', 4500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 11, '에그타르트 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 12, '골드 엣지로 변경', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 12, '크림치즈 엣지로 변경', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 12, '치즈캡 엣지로 변경', 4500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 12, '에그타르트 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 13, '씬 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 13, '치즈롤 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 13, '골드링 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 13, '2블랜드 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 13, '3블랜드 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 13, '엑스트라 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 13, '체다 치즈 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 14, '씬 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 14, '치즈롤 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 14, '골드링 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 14, '2블랜드 치즈 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 14, '3블랜드 치즈 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 14, '엑스트라 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 14, '체다 치즈 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 15, '씬 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 15, '치즈롤 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 15, '골드링 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 15, '2블랜드 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 15, '3블랜드 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 15, '엑스트라 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 15, '체다 치즈 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 16, '씬 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 16, '치즈롤 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 16, '골드링 도우로 변경', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 16, '2블랜드 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 16, '3블랜드 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 16, '엑스트라 치즈 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 16, '체다 치즈 추가', 1500);





--치킨(101)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 101, '푸라닭 부산해운대점', '48065', '부산광역시 해운대구 해운대로 483번길 1-7', '1층',
            '0517469207', '\img\puradak.jpg', '\img\puradak.jpg', 8, 23, 15900, 50, 4000, '푸라닭 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 101, 'BBQ치킨 해운대비치점', '48096', '부산광역시 해운대구 해운대해변로359번길 27', '1층',
            '0517310778', '\img\bbq.jpg', '\img\bbq.jpg', 8, 23, 16000, 55, 3000, 'BBQ치킨 해운대비치점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 101, '교촌치킨 해운대역점', '48094', '부산광역시 해운대구 해운대로 604', '1층',
        '0517469288', '\img\kyochon.jpg', '\img\kyochon.jpg', 8, 23, 16000, 50, 3000, '교촌치킨 해운대역점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 101, 'BHC치킨 해운대중동점', '48096', '부산광역시 해운대구 좌동순환로 503', '2층',
            '0517310087', '\img\bhc.jpg', '\img\bhc.jpg', 8, 23, 16000, 45, 3000, 'BHC치킨 해운대중동점입니다.');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 5, '푸라닭 치킨', '16900', '푸라닭 치킨입니다', '\img\puradak_1.jpg', '\img\puradak_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 5, '고추마요 치킨', '18900', '고추마요 치킨입니다', '\img\puradak_2.jpg', '\img\puradak_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 5, '콘소메이징 치킨', '18900', '콘소메이징 치킨입니다', '\img\puradak_3.jpg', '\img\puradak_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 5, '블랙알리오 치킨', '18900', '블랙알리오 치킨입니다', '\img\puradak_4.jpg', '\img\puradak_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 6, '황금올리브 치킨', '20000', '황금올리브 치킨입니다', '\img\bbq_1.jpg', '\img\bbq_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 6, '자메이카 통다리구이', '21500', '자메이카 통다리구이입니다', '\img\bbq_2.jpg', '\img\bbq_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 6, '오리지날 양념치킨', '21500', '오리지날 양념치킨입니다', '\img\bbq_3.jpg', '\img\bbq_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 6, '황올한 깐풍치킨', '22000', '황올한 깐풍치킨입니다', '\img\bbq_4.jpg', '\img\bbq_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 7, '교촌허니콤보', '20000', '교촌허니콤보입니다', '\img\kyochon_1.jpg', '\img\kyochon_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 7, '교촌레드콤보', '20000', '교촌레드콤보입니다', '\img\kyochon_2.jpg', '\img\kyochon_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 7, '교촌블랙시크릿오리지날', '20000', '교촌 블랙시크릿오리지날입니다', '\img\kyochon_3.jpg', '\img\kyochon_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 7, '발사믹 치킨', '18500', '발사믹 치킨입니다', '\img\kyochon_4.jpg', '\img\kyochon_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 8, '뿌링클 치킨', '18000', '뿌링클 치킨입니다', '\img\bhc_1.jpg', '\img\bhc_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 8, '맛초킹 치킨', '18000', '맛초킹 치킨입니다', '\img\bhc_2.jpg', '\img\bhc_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 8, '골드킹 치킨', '17000', '골드킹 치킨입니다', '\img\bhc_3.jpg', '\img\bhc_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 8, '커리퀸 치킨', '18000', '커리퀸 치킨입니다', '\img\bhc_4.jpg', '\img\bhc_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 17, '떡 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 17, '웨지감자 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 17, '콘소메 치즈볼 추가', 5900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 17, '콘소메 빅치즈스틱 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 18, '떡 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 18, '웨지감자 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 18, '콘소메 치즈볼 추가', 5900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 18, '콘소메 빅치즈스틱 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 19, '떡 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 19, '웨지감자 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 19, '콘소메 치즈볼 추가', 5900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 19, '콘소메 빅치즈스틱 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 20, '떡 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 20, '웨지감자 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 20, '콘소메 치즈볼 추가', 5900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 20, '콘소메 빅치즈스틱 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 21, '황금알치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 21, 'BBQ소떡소떡 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 21, '치킨무 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 21, '즉석밥 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 22, '황금알치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 22, 'BBQ소떡소떡 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 22, '치킨무 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 22, '즉석밥 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 23, '황금알치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 23, 'BBQ소떡소떡 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 23, '치킨무 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 23, '즉석밥 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 24, '황금알치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 24, 'BBQ소떡소떡 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 24, '치킨무 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 24, '즉석밥 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 25, '레드디핑소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 25, '고르곤치즈볼 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 25, '교촌쫀드칸꽈배기(콘치즈) 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 25, '교촌쫀드칸꽈배기(시나몬슈가) 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 26, '레드디핑소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 26, '고르곤치즈볼 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 26, '교촌쫀드칸꽈배기(콘치즈) 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 26, '교촌쫀드칸꽈배기(시나몬슈가) 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 27, '레드디핑소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 27, '고르곤치즈볼 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 27, '교촌쫀드칸꽈배기(콘치즈) 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 27, '교촌쫀드칸꽈배기(시나몬슈가) 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 28, '레드디핑소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 28, '고르곤치즈볼 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 28, '교촌쫀드칸꽈배기(콘치즈) 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 28, '교촌쫀드칸꽈배기(시나몬슈가) 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 29, '뿌링뿌링소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 29, '뿌링소떡 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 29, '달콤바삭치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 29, '뿌링치즈볼 추가', 5500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 30, '뿌링뿌링소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 30, '뿌링소떡 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 30, '달콤바삭치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 30, '뿌링치즈볼 추가', 5500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 31, '뿌링뿌링소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 31, '뿌링소떡 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 31, '달콤바삭치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 31, '뿌링치즈볼 추가', 5500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 32, '뿌링뿌링소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 32, '뿌링소떡 추가', 3500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 32, '달콤바삭치즈볼 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 32, '뿌링치즈볼 추가', 5500);





--패스트푸드(102)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 102, '맥도날드', '48094', '부산광역시 해운대구 해운대로570번길 51', '1층',
            '07072091629', '\img\mcdonald.jpg', '\img\mcdonald.jpg', 8, 23, 3000, 60, 2500, '맥도날드 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 102, '버거킹', '48094', '부산광역시 해운대구 구남로 27', '1층',
            '0517310054', '\img\burgerking.jpg', '\img\burgerking.jpg', 8, 23, 13000, 60, 0, '버거킹 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 102, '롯데리아', '48094', '부산 해운대구 해운대로 592', '1층',
            '0517310218', '\img\lotte.jpg', '\img\lotte.jpg', 8, 23, 10000, 45, 3500, '롯데리아 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 102, '맘스터치', '48083', '부산광역시 해운대구 대천로67번길 15', '신성아파트',
            '0517310054', '\img\moms.jpg', '\img\moms.jpg', 8, 23, 8000, 35, 4000, '맘스터치 해운대점입니다.');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 9, '빅맥 세트', '7500', '빅맥 세트입니다', '\img\mcdonald_1.jpg', '\img\mcdonald_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 9, '맥스파이시 상하이버거 세트', '7500', '맥스파이시 상하이버거 세트입니다', '\img\mcdonald_2.jpg', '\img\mcdonald_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 9, '1955 버거 세트', '8800', '1955 버거 세트입니다', '\img\mcdonald_3.jpg', '\img\mcdonald_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 9, '창녕 갈릭 버거 세트', '9200', '창녕 갈비 버거 세트입니다', '\img\mcdonald_4.jpg', '\img\mcdonald_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 10, '몬스터X 세트', '12300', '몬스터X 세트입니다', '\img\burgerking_1.jpg', '\img\burgerking_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 10, '불고기와퍼 세트', '10100', '불고기와퍼 세트입니다', '\img\burgerking_2.jpg', '\img\burgerking_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 10, '통새우와퍼 세트', '10900', '통새우와퍼 세트입니다', '\img\burgerking_3.jpg', '\img\burgerking_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 10, '텍사스칠리와퍼 세트', '10800', '텍사스칠리와퍼 세트입니다', '\img\burgerking_4.jpg', '\img\burgerking_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 11, '불고기버거 세트', '6600', '불고기버거 세트입니다', '\img\lotte_1.jpg', '\img\lotte_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 11, '새우버거 세트', '6600', '새우버거 세트입니다', '\img\lotte_2.jpg', '\img\lotte_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 11, '한우불고기 세트', '9700', '한우불고기 세트입니다', '\img\lotte_3.jpg', '\img\lotte_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 11, '핫크리스피버거 세트', '7400', '핫크리스피버거 세트입니다', '\img\lotte_4.jpg', '\img\lotte_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 12, '싸이버거 세트', '6600', '싸이버거 세트입니다', '\img\moms_1.jpg', '\img\moms_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 12, '화이트갈릭싸이버거 세트', '7200', '화이트갈릭싸이버거 세트입니다', '\img\moms_2.jpg', '\img\moms_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 12, '딥치즈싸이버거 세트', '7100', '딥치즈싸이버거 세트입니다', '\img\moms_3.jpg', '\img\moms_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 12, '언블리버블버거 세트', '7900', '언블리버블버거 세트입니다', '\img\moms_4.jpg', '\img\moms_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 33, '코울슬로 추가', 2700);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 33, '맥너겟 4조각 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 33, '골든 모짜렐라 치즈스틱 2조각 추가', 3300);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 33, '맥윙 2조각 추가', 3700);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 34, '코울슬로 추가', 2700);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 34, '맥너겟 4조각 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 34, '골든 모짜렐라 치즈스틱 2조각 추가', 3300);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 34, '맥윙 2조각 추가', 3700);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 35, '코울슬로 추가', 2700);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 35, '맥너겟 4조각 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 35, '골든 모짜렐라 치즈스틱 2조각 추가', 3300);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 35, '맥윙 2조각 추가', 3700);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 36, '코울슬로 추가', 2700);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 36, '맥너겟 4조각 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 36, '골든 모짜렐라 치즈스틱 2조각 추가', 3300);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 36, '맥윙 2조각 추가', 3700);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 37, '프렌치프라이L 교환', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 37, '네겟킹 4조각 교환', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 37, '치츠프라이 교환', 900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 37, '어니언링 교환', 300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 38, '프렌치프라이L 교환', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 38, '네겟킹 4조각 교환', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 38, '치츠프라이 교환', 900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 38, '어니언링 교환', 300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 39, '프렌치프라이L 교환', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 39, '네겟킹 4조각 교환', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 39, '치츠프라이 교환', 900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 39, '어니언링 교환', 300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 40, '프렌치프라이L 교환', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 40, '네겟킹 4조각 교환', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 40, '치츠프라이 교환', 900);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 40, '어니언링 교환', 300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 41, '모짜크림치즈볼 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 41, '통오징어링 추가', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 41, '치즈스틱 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 41, '치킨 1조각 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 42, '모짜크림치즈볼 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 42, '통오징어링 추가', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 42, '치즈스틱 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 42, '치킨 1조각 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 43, '모짜크림치즈볼 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 43, '통오징어링 추가', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 43, '치즈스틱 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 43, '치킨 1조각 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 44, '모짜크림치즈볼 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 44, '통오징어링 추가', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 44, '치즈스틱 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 44, '치킨 1조각 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 45, '치즈감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 45, 'NEW치즈뿌치감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 45, '케이준양념감자(대) 사이즈업', 1300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 46, '치즈감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 46, 'NEW치즈뿌치감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 46, '케이준양념감자(대) 사이즈업', 1300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 47, '치즈감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 47, 'NEW치즈뿌치감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 47, '케이준양념감자(대) 사이즈업', 1300);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 48, '치즈감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 48, 'NEW치즈뿌치감자로 변경', 1200);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 48, '케이준양념감자(대) 사이즈업', 1300);





--분식(103)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 103, '동대문엽기떡볶이', '48059', '부산광역시 해운대구 센텀동로 9', '트럼프월드센텀아파트',
            '0517468598', '\img\dong.jpg', '\img\dong.jpg', 8, 23, 14000, 60, 3000, '동대문엽기떡볶이 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 103, '신전떡볶이', '48095', '부산광역시 해운대구 중동1로 30', '1층',
            '0517478855', '\img\sin.jpg', '\img\sin.jpg', 8, 23, 9000, 55, 4000, '신전떡볶이 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 103, '배떡', '48062', '부산광역시 해운대구 해운대로383번길 9', '1층',
            '050713755847', '\img\bae.jpg', '\img\bae.jpg', 8, 23, 9000, 40, 4000, '배떡 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 103, '청년다방', '48058', '부산광역시 해운대구 센텀중앙로 97', '센텀스카이비즈 B1층 B113호',
            '0517847161', '\img\jean.jpg', '\img\jean.jpg', 8, 23, 9500, 30, 4000, '청년다방 해운대점입니다.');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 13, '엽기떡볶이', '14000', '엽기 떡볶이입니다', '\img\dong_1.jpg', '\img\dong_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 13, '로제떡볶이', '16000', '로제 떡볶이입니다', '\img\dong_2.jpg', '\img\dong_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 13, '크림떡볶이', '15000', '크림 떡볶이입니다', '\img\dong_3.jpg', '\img\dong_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 13, '엽기닭볶음탕', '24000', '엽기 닭볶음탕입니다', '\img\dong_4.jpg', '\img\dong_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 14, '신전떡볶이', '3500', '신전 떡볶이입니다', '\img\sin_1.jpg', '\img\sin_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 14, '치즈떡볶이', '5500', '치즈 떡볶이입니다', '\img\sin_2.jpg', '\img\sin_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 14, '신전 로제떡볶이', '5500', '신전 로제떡볶이입니다', '\img\sin_3.jpg', '\img\sin_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 14, '신전치즈김밥', '4000', '신전 치즈김밥입니다', '\img\sin_4.jpg', '\img\sin_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 15, '로제떡볶이', '10000', '로제 떡볶이입니다', '\img\bae_1.jpg', '\img\bae_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 15, '분모자떡볶이', '12000', '분모자 떡볶이입니다', '\img\bae_2.jpg', '\img\bae_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 15, '국물떡볶이', '6000', '국물떡볶이입니다', '\img\bae_3.jpg', '\img\bae_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 15, '짜장떡볶이', '6000', '짜장떡볶이입니다', '\img\bae_4.jpg', '\img\bae_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 16, '차돌떡볶이', '16500', '차돌 떡볶이입니다', '\img\jean_1.jpg', '\img\jean_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 16, '통큰오짱떡볶이', '16500', '통큰오짱 떡볶이입니다', '\img\jean_2.jpg', '\img\jean_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 16, '피자로니떡볶이', '16500', '피자로니 떡볶이입니다', '\img\jean_3.jpg', '\img\jean_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 16, '맵다방떡볶이', '13000', '맵다방 떡볶이입니다', '\img\jean_4.jpg', '\img\jean_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 49, '모짜치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 49, '베이컨 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 49, '퐁당치즈만두(7개) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 49, '중국당면 추가', 2500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 49, '분모자 추가', 2500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 50, '모짜치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 50, '베이컨 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 50, '퐁당치즈만두(7개) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 50, '중국당면 추가', 2500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 50, '분모자 추가', 2500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 51, '모짜치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 51, '베이컨 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 51, '퐁당치즈만두(7개) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 51, '중국당면 추가', 2500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 51, '분모자 추가', 2500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 52, '모짜치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 52, '베이컨 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 52, '퐁당치즈만두(7개) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 52, '중국당면 추가', 2500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 52, '분모자 추가', 2500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 53, '납작면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 53, '치즈토핑 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 53, '더블치즈토핑 추가', 4000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 54, '납작면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 54, '치즈토핑 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 55, '납작면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 55, '치즈토핑 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 56, '치즈토핑 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 57, '분모자 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 57, '중국당면 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 57, '비엔나 5개 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 57, '치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 57, '베이컨 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 58, '분모자 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 58, '중국당면 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 58, '비엔나 5개 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 58, '치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 58, '베이컨 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 59, '분모자 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 59, '중국당면 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 59, '비엔나 5개 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 59, '치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 59, '베이컨 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 60, '분모자 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 60, '중국당면 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 60, '비엔나 5개 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 60, '치즈 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 60, '베이컨 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 61, '넓적당면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 61, '탱탱쫄면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 61, '꽃분모자(3줄) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 61, '쫀득치즈 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 62, '넓적당면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 62, '탱탱쫄면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 62, '꽃분모자(3줄) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 62, '쫀득치즈 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 63, '넓적당면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 63, '탱탱쫄면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 63, '꽃분모자(3줄) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 63, '쫀득치즈 추가', 3500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 64, '넓적당면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 64, '탱탱쫄면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 64, '꽃분모자(3줄) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 64, '쫀득치즈 추가', 3500);





--카페/디저트(104)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 104, '설빙', '48094', '부산광역시 해운대구 구남로 20', '1층',
            '0517466411', '\img\sulbing.jpg', '\img\sulbing.jpg', 8, 23, 8000, 55, 3500, '설빙 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 104, '컴포즈커피', '48060', '부산광역시 해운대구 센텀2로 25', '센텀드림월드 107호 컴포즈커피 벡스코점',
            '0517470277', '\img\compose.jpg', '\img\compose.jpg', 8, 23, 6500, 45, 1700, '컴포즈커피 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 104, '디저트39', '48096', '부산광역시 해운대구 해운대해변로357번길 17', '101호',
            '0517477002', '\img\d39.jpg', '\img\d39.jpg', 8, 23, 5000, 45, 4000, '디저트39 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 104, '메가커피', '48095', '부산광역시 해운대구 중동1로 35', '1층',
            '0519117675', '\img\mega.jpg', '\img\mega.jpg', 8, 23, 16000, 45, 2300, '메가커피 해운대점입니다.');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 17, '요거통통메론설빙', '15900', '요거통통메론 설빙입니다', '\img\sulbing_1.jpg', '\img\sulbing_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 17, '딸기치즈메론설빙', '16900', '딸기치즈메론 설빙입니다', '\img\sulbing_2.jpg', '\img\sulbing_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 17, '애플망고치즈설빙', '12900', '애플망고치즈 설빙입니다', '\img\sulbing_3.jpg', '\img\sulbing_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 17, '인절미설빙', '8900', '인절미 설빙입니다', '\img\sulbing_4.jpg', '\img\sulbing_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 18, '커피밀크쉐이크', '4700', '커피밀크 쉐이크입니다', '\img\compose_1.jpg', '\img\compose_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 18, '딸기스무디', '4000', '딸기 스무디입니다', '\img\compose_2.jpg', '\img\compose_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 18, '리얼초코자바칩프라페', '4400', '리얼초코자바칩 프라페입니다', '\img\compose_3.jpg', '\img\compose_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 18, '수박주스', '4400', '수박 주스입니다', '\img\compose_4.jpg', '\img\compose_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 19, '프리미엄 딸기라떼', '5800', '프리미엄 딸기라떼입니다', '\img\d39_1.jpg', '\img\d39_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 19, '아메리카노', '3900', '아메리카노입니다', '\img\d39_2.jpg', '\img\d39_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 19, '프리미엄 망고라떼', '5800', '프리미엄 망고라떼입니다', '\img\d39_3.jpg', '\img\d39_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 19, '치즈프로마쥬 카라멜마끼아또', '6800', '치즈프로마쥬 카라멜마끼아또입니다', '\img\d39_4.jpg', '\img\d39_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 20, '큐브라떼', '4700', '큐브라떼입니다', '\img\mega_1.jpg', '\img\mega_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 20, '사과 생크림 와플', '3000', '샤과 생크림 와플입니다', '\img\mega_2.png', '\img\mega_2.png');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 20, '플레인크로플', '3000', '플레인 크로플입니다', '\img\mega_3.jpg', '\img\mega_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 20, '춘천감자빵', '7000', '춘천감자빵입니다', '\img\mega_4.jpg', '\img\mega_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 65, '연유소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 65, '큐브치즈케이크 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 65, '브라우니 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 65, '찹쌀떡 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 66, '연유소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 66, '큐브치즈케이크 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 66, '브라우니 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 66, '찹쌀떡 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 67, '연유소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 67, '큐브치즈케이크 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 67, '브라우니 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 67, '찹쌀떡 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 68, '연유소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 68, '큐브치즈케이크 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 68, '브라우니 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 68, '찹쌀떡 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 69, '바닐라시럽 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 69, '헤이즐넛시럽 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 69, '펄 추가', 700);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 70, '휘핑크림 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 70, '펄 추가', 700);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 71, '펄 추가', 700);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 72, '휘핑크림 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 72, '펄 추가', 700);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 72, '샷 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 73, '타피오카펄 추가', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 73, '코코넛젤리 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 74, '샷 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 74, '헤이즐넛시럽 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 75, '타피오카펄 추가', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 75, '코코넛젤리 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 76, '타피오카펄 추가', 800);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 76, '코코넛젤리 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 77, '샷 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 77, '에스프레소 큐브 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 78, '사과잼 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 78, '생크림 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 78, '크림치즈 포션 추가', 800);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 79, '휘핑 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 79, '초코소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 79, '카라멜소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 79, '크림치즈 포션 추가', 800);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 80, '휘핑 추가', 500);





--돈까스/일식(105)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 105, '경양카츠 해리단길점', '48088', '부산광역시 해운대구 우동1로 13-29', '1층',
            '0518945620', '\img\kyungyang_logo.jpg', '\img\kyungyang_logo.jpg', 8, 23, 12000, 30, 3000, '경양카츠 해리단길점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 105, '오덕돈까스 본점', '48084', '부산광역시 해운대구 좌동순환로 49', '1층',
            '0518945620', '\img\oduk_logo.jpg', '\img\oduk_logo.jpg', 8, 23, 14000, 40, 2500, '경양식 돈까스가 좋은 오덕돈까스 본점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 105, '해목 해운대점', '48094', '부산광역시 해운대구 구남로24번길 8', '1층',
            '0517463730', '\img\haemok_logo.jpg', '\img\haemok_logo.jpg', 8, 23, 38000, 50, 1000, '히츠마부시(장어덮밥) 전문점 해목 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 105, '카가와식당 해리단길점', '48087', '부산광역시 해운대구 우동1로 6', '1층',
            '01074756106', '\img\kagawa_logo.jpg', '\img\kagawa_logo.jpg', 8, 23, 14000, 45, 2000, '일식 카레 전문점 카가와식당 해리단길점입니다.');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 21, '등심카츠', '13900', '가장 많이 사용되는 부위인 등심으로 만든 카츠입니다. 등심의 담백함을 맛보실 수 있습니다.',
            '\img\kyungyang_1.jpg', '\img\kyungyang_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 21, '안심카츠', '12900', '부드럽고 육즙이 많아 풍미가 좋은 부위인 안심살로 만든 카츠입니다.',
            '\img\kyungyang_2.jpg', '\img\kyungyang_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 21, '치즈카츠', '13800', '돼지 등심에 천연 치즈를 감싸서 튀긴 카츠입니다.',
            '\img\kyungyang_3.jpg', '\img\kyungyang_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 21, '안심+등심카츠', '14900', '부드럽고 육즙이 많은 안심과 쫄깃하고 담백한 등심을 한 번에 맛보실 수 있습니다.',
            '\img\kyungyang_4.jpg', '\img\kyungyang_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 22, '오덕돈까스', '9000', '기본 경양식 돈까스',
            '\img\oduk_1.jpg', '\img\oduk_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 22, '오덕치즈돈까스', '10500', '모짜렐라 치즈가 듬뿍있는 돈까스',
            '\img\oduk_2.jpg', '\img\oduk_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 22, '왕교자만두(6P)', '5000', '바싹하게 튀겨낸 속이 꽉찬 만두',
            '\img\oduk_3.jpg', '\img\oduk_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 22, '몽짬뽕', '8500', '강한 화력에 볶아낸 걸쭉하고 진한 짬뽕',
            '\img\oduk_4.jpg', '\img\oduk_4.jpg');            

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 23, '히츠마부시', '38000', '민물장어덮밥',
            '\img\haemok_1.jpg', '\img\haemok_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 23, '카이센동', '35000', '해산물덮밥',
            '\img\haemok_2.jpg', '\img\haemok_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 23, '생연어+참치', '26000', '연어와 참치를 한번에',
            '\img\haemok_3.jpg', '\img\haemok_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 23, '어린이 장어덮밥', '10000', '어린이용 장어덮밥',
            '\img\haemok_4.jpg', '\img\haemok_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 24, '카가와 큐브스테이크카레', '15500', '적당히 구워진 두툼하게 조각낸 스테이크, 터지는 육즙과 함께 깊은 풍미를 느낄 수 있는 메뉴',
            '\img\kagawa_1.jpg', '\img\kagawa_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 24, '카가와 밀푀유카츠카레', '14500', '겉바속촉! 얇게 썬 고기를 돌돌 말아서 층층이 쌓아 튀긴 카가와식당의 시그니처 메뉴!',
            '\img\kagawa_2.jpg', '\img\kagawa_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 24, '카가와 안심카레카츠', '14500', '부드러운 안심이 입안에서 제대로 터지는 육즙을 맛볼 수 있는 메뉴',
            '\img\kagawa_3.jpg', '\img\kagawa_3.jpg');            
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 24, '카가와 통삼겹카레', '14000', '부드럽게 씹히는 다진고기와 야들야들한 통삼겹살이 함께 어우러져 즐거운 향연을 선사하는 메뉴',
            '\img\kagawa_4.jpg', '\img\kagawa_4.jpg');
            
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 81, '콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 81, '스프라이트 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 81, '소스 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 82, '콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 82, '스프라이트 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 82, '소스 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 83, '콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 83, '스프라이트 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 83, '소스 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 84, '콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 84, '스프라이트 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 84, '소스 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 85, '콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 85, '제로콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 85, '소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 85, '미소국 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 86, '콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 86, '제로콜라 1.5L 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 86, '치즈 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 86, '미소국 추가', 500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 87, '2P 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 87, '콜라 500ml 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 88, '곱빼기로 변경', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 88, '공기밥 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 89, '특으로 변경', 18000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 89, '모찌리도후 추가', 9000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 89, '크림 부라타치즈 추가', 8000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 90, '특으로 변경', 14000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 90, '모찌리도후 추가', 9000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 90, '크림 부라타치즈 추가', 8000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 91, '아보카도 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 92, '계란국 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 93, '눈꽃치즈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 93, '온센타마고 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 93, '반숙계란튀김 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 93, '공기밥 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 94, '눈꽃치즈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 94, '온센타마고 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 94, '반숙계란튀김 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 94, '공기밥 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 95, '눈꽃치즈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 95, '온센타마고 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 95, '반숙계란튀김 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 95, '공기밥 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 96, '눈꽃치즈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 96, '온센타마고 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 96, '반숙계란튀김 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 96, '공기밥 추가', 1000);





--중국집(106)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 106, '라호짬뽕', '48118', '부산광역시 해운대구 마린시티1로 137', '대우월드마크 110호',
            '0517311222', '\img\laho_logo.jpg', '\img\laho_logo.jpg', 8, 23, 10000, 30, 2000, '클래식 중식을 기반으로 한 중식 전문점 라호짬뽕입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 106, '용각산', '48111', '부산광역시 해운대구 세실로 43', '경동코아상가 105호',
            '0517031125', '\img\yong_logo.jpg', '\img\yong_logo.jpg', 8, 23, 20000, 40, 1000, '해운대 장산의 고급스러운 중국요리 전문점 용각산입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 106, '락핫팟', '48093', '부산광역시 해운대구 해운대해변로209번가길 11', '2층',
            '0517311341', '\img\rockhot_logo.jpg', '\img\rockhot_logo.jpg', 8, 23, 25000, 50, 2500, '중국 사천의 전통 요리법을 바탕으로 최고급 품질의 재료에 현대적이고 예술적인 감각으로 재해석한 사천식 훠궈 브랜드입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 106, '홍콩반점0410 부산장산역점', '48106', '부산광역시 해운대구 양운로92', '나하나빌딩 1층',
            '0517020418', '\img\hongkong_logo.jpg', '\img\hongkong_logo.jpg', 8, 23, 12000, 40, 2000, '홍콩반점0410 부산장산역점입니다.');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 25, '라짬뽕', '10000', '돼지사골, 닭, 채소 3가지 육수를 블렌딩해서 만든 육수에 알칼리수로 제면한 면을 사용하여 깊고 고급스런 빨간 짬뽕입니다.',
            '\img\laho_1.jpg', '\img\laho_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 25, '호짬뽕', '11000', '돼지사골, 닭, 채소 3가지 육수를 블렌딩해서 만든 육수에 알칼리수로 제면한 면을 사용하여 깊고 고급스런 하얀 짬뽕입니다.',
            '\img\laho_2.jpg', '\img\laho_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 25, '간짜장', '9000', '불향과 채소의 아삭한 풍미들이 살아있는 제대로 된 간짜장입니다.',
            '\img\laho_3.jpg', '\img\laho_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 25, '양주식볶음밥', '10000', '자스민 라이스와 신동진 품종의 쌀을 6:4 비율로 섞어 고슬고슬한 식감이 일품인 볶음밥입니다.',
            '\img\laho_4.jpg', '\img\laho_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 26, '중화 찹스테이크', '37000', '큐브로 썬 소고기 살치살과 여러가지 야채를 불맛나게 볶아낸 요리',
            '\img\yong_1.jpg', '\img\yong_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 26, '고추잡채', '22000', '채썬 피망과 고기에 굴소스를 넣고 볶아낸 요리 with 꽃빵',
            '\img\yong_2.jpg', '\img\yong_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 26, '팔보채', '32000', '전복, 해삼, 갑오징어, 새우, 송이버섯 등을 매콤하게 볶아낸 요리',
            '\img\yong_3.jpg', '\img\yong_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 26, '양장피', '30000', '여러가지 야채와 전복, 새우, 갑오징어를 깔고 볶아낸 양장피를 곁들인 요리',
            '\img\yong_4.jpg', '\img\yong_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 27, '고기훠궈세트(1인)', '25000', '토종닭과 신선한 재료를 넣어 푹 우려낸 육수로 만든 백탕과 홍탕의 훠궈',
            '\img\rockhot_1.jpg', '\img\rockhot_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 27, '해산물마라탕', '17000', '각종 채소로 우려낸 육수와 마라의 만남',
            '\img\rockhot_2.jpg', '\img\rockhot_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 27, '오향장육', '25000', '돼지고기의 진수를 맛볼 수 있는 오향장육입니다.',
            '\img\rockhot_3.jpg', '\img\rockhot_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 27, '꿔바로우', '15000', '바삭한 튀김과 부드러운 소스의 조화가 일품인 꿔바로우입니다.',
            '\img\rockhot_4.jpg', '\img\rockhot_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 28, '짬뽕', '7000', '볶을 때 배어나는 중식 화력 특유의 은은하고 구수한 불 내음이 특징이며, 매운맛의 원천인 사천고추로 얼큰하고 칼칼한 맛을 내었습니다.',
            '\img\hongkong_1.jpg', '\img\hongkong_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 28, '짜장면', '6000', '중식특유의 불향이 가득한 명품 짜장면!',
            '\img\hongkong_2.jpg', '\img\hongkong_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 28, '탕수육(소)', '14900', '홍콩반점0410의 비법 소스를 곁들인 음식으로 인절미 같은 쫄깃한 식감으로 인해 일반 탕수육과는 차별화된 최고의 인기 메뉴입니다.',
            '\img\hongkong_3.jpg', '\img\hongkong_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 28, '쟁반짜장', '14000', '더욱 풍성하게 들어간 야채와 고기, 그리고 해산물을 홍콩반점 특유의 불맛으로 볶아낸 후 매콤함까지 더했습니다.',
            '\img\hongkong_4.jpg', '\img\hongkong_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 97, '곱빼기로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 97, '공기밥 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 97, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 98, '곱빼기로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 98, '공기밥 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 98, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 99, '곱빼기로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 99, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 100, '곱빼기로 변경', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 100, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 101, '꽃빵(4P) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 101, '고수 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 101, '만두(6P) 추가', 6000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 101, '공기밥 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 101, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 102, '꽃빵(4P) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 102, '고수 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 102, '만두(6P) 추가', 6000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 102, '공기밥 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 102, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 103, '꽃빵(4P) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 103, '고수 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 103, '만두(6P) 추가', 6000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 103, '공기밥 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 103, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 104, '꽃빵(4P) 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 104, '고수 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 104, '만두(6P) 추가', 6000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 104, '공기밥 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 104, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 105, '야채바구니 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 105, '모듬버섯바구니 추가', 10000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 105, '튀긴두부 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 105, '모듬볼 추가', 10000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 105, '라면사리 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 105, '공기밥 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 106, '고기 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 106, '전복(1P) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 106, '넓적당면 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 107, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 108, '탄산음료 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 109, '곱빼기로 변경', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 109, '콜라 500ml 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 109, '공기밥 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 110, '곱빼기로 변경', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 110, '콜라 500ml 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 110, '공기밥 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 111, '사이드 대로 변경', 10000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 111, '콜라 500ml 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 111, '공기밥 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 112, '콜라 500ml 추가', 2000);





--족발/보쌈(107)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 107, '깐깐한족발 해운대점', '48106', '부산광역시 해운대구 양운로80번길 8', '1층',
            '0517022292', '\img\kk_logo.jpg', '\img\kk_logo.jpg', 8, 23, 35000, 50, 2000, '참숯으로 구운 깐깐한족발입니다. 우리 아이가 먹지 못할 족발은 만들지도 않겠습니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 107, '도야족발 해운대점', '48097', '부산광역시 해운대구 대천로106번길 21', '1층',
            '0517049531', '\img\doya_logo.jpg', '\img\doya_logo.jpg', 8, 23, 35000, 40, 2000, '모든 음식에 정성을 담으며 대충 만들어 판매할 바엔 판매를 하지 않겠습니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 107, '마왕족발 부산장산점', '48111', '부산광역시 해운대구 양운로42번길 18', '에이원웨이 1층 102호',
            '0517046999', '\img\mawang_logo.jpg', '\img\mawang_logo.jpg', 8, 23, 30000, 50, 3000, '지금까지 경험하지 못한 족발의 신세계, 오늘 저녁 마왕의 세계로 여러분들을 초대합니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 107, '원할머니보쌈족발 부산해운대중동점', '48101', '부산광역시 해운대구 좌동순환로 502', '1층',
            '0517470353', '\img\onegrandma_logo.jpg', '\img\onegrandma_logo.jpg', 8, 23, 30000, 60, 2500, '세대를 이어가는 정성의 맛, 원할머니 보쌈족발 부산해운대중동점입니다.');

           
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 29, '참숯구이족발', '35000', '참숯으로 정성들여 한 번 더 구워 담백한 맛과 부드럽고 쫀득쫀득한 맛이 일품인 족발요리',
            '\img\kk_1.jpg', '\img\kk_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 29, '반반족발', '41000', '모든 메뉴 중 두가지 메뉴를 한 번에 맛볼 수 있는 최고 인기 메뉴',
            '\img\kk_2.jpg', '\img\kk_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 29, '직화매운족발', '35000', '정성스럽게 삶아 낸 족발에 특제 매운소스를 가미하여 직화로 구워 불향이 일품인 족발요리',
            '\img\kk_3.jpg', '\img\kk_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 29, '옛날식왕족발', '35000', '정성스럽게 삶아낸 족발을 차갑게 식혀 얇게 슬라이스하여 푸짐해보이며 식감이 쫄깃쫄깃한게 특징인 족발요리',
            '\img\kk_4.jpg', '\img\kk_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 30, '반반족발(2~3인분)', '36000', '뒷발+불족발+막국수+무김치+백김치+양파+오이고추+생마늘+와사비간장+새우젓+쌈장+오뎅탕+쌈야채+콜라',
            '\img\doya_1.jpg', '\img\doya_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 30, '불족발(2~3인분)', '35000', '족발+막국수+무김치+백김치+양파+오이고추+생마늘+와사비간장+새우젓+쌈장+오뎅탕+쌈야채+콜라',
            '\img\doya_2.jpg', '\img\doya_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 30, '데리야끼족발(2~3인분)', '35000', '족발+막국수+무김치+백김치+양파+오이고추+생마늘+와사비간장+새우젓+쌈장+오뎅탕+쌈야채+콜라',
            '\img\doya_3.jpg', '\img\doya_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 30, '보쌈(2~3인분)', '35000', '보쌈+막국수+무김치+백김치+양파+오이고추+생마늘+와사비간장+새우젓+쌈장+오뎅탕+쌈야채+콜라+보쌈김치',
            '\img\doya_4.jpg', '\img\doya_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 31, '마왕통구이(소)', '30000', '매운맛/중간맛/순한맛 선택가능',
            '\img\mawang_1.jpg', '\img\mawang_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 31, '천사세트(중)', '42000', '마왕족발 인기메뉴 통구이와 갈릭, 불족, 소금구이를 동시에 즐기는 꿀조합 세트',
            '\img\mawang_2.jpg', '\img\mawang_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 31, '보쌈구이(소)', '30000', '매운맛/중간맛/순한맛 선택가능',
            '\img\mawang_3.jpg', '\img\mawang_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 31, '마왕불족발(중)', '36000', '스트레스를 확 날려주는 중독성 강한 매운맛의 바베큐 족발',
            '\img\mawang_4.jpg', '\img\mawang_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 32, '모둠보쌈(소)', '34000', '원할머니의 대표메뉴로 보쌈고기와 다양한 김치, 쌈류를 즐기실 수 있습니다.',
            '\img\onegrandma_1.jpg', '\img\onegrandma_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 32, '보족원쌈(2인)', '46000', '보쌈과 족발이 동시에 제공되는 인기메뉴입니다.',
            '\img\onegrandma_2.jpg', '\img\onegrandma_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 32, '실속원쌈(3인)', '48000', '실속있는 구성으로 맛있게 드실 수 있습니다.',
            '\img\onegrandma_3.jpg', '\img\onegrandma_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 32, '커플원쌈', '43000', '둘이서 쟁반면과 함께 푸짐하게 드실 수 있는 메뉴입니다.',
            '\img\onegrandma_4.jpg', '\img\onegrandma_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 113, '날치알 주먹밥 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 113, '푸딩 계란찜 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 113, '비빔막국수 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 113, '수제어묵탕 추가', 10000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 114, '날치알 주먹밥 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 114, '푸딩 계란찜 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 114, '비빔막국수 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 114, '수제어묵탕 추가', 10000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 115, '날치알 주먹밥 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 115, '푸딩 계란찜 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 115, '비빔막국수 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 115, '수제어묵탕 추가', 10000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 116, '날치알 주먹밥 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 116, '푸딩 계란찜 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 116, '비빔막국수 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 116, '수제어묵탕 추가', 10000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 117, '마늘소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 117, '주먹밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 117, '막국수 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 117, '쌈야채 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 117, '무김치(150g) 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 118, '마늘소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 118, '주먹밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 118, '막국수 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 118, '쌈야채 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 118, '무김치(150g) 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 119, '마늘소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 119, '주먹밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 119, '막국수 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 119, '쌈야채 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 119, '무김치(150g) 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 120, '마늘소스 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 120, '주먹밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 120, '막국수 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 120, '쌈야채 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 120, '무김치(150g) 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 121, '쟁반국수(2인) 추가', 13000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 121, '족발볶음밥(1인) 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 121, '반찬 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 121, '쌈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 121, '콜라 500ml 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 122, '쟁반국수(2인) 추가', 13000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 122, '족발볶음밥(1인) 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 122, '반찬 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 122, '쌈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 122, '콜라 500ml 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 123, '쟁반국수(2인) 추가', 13000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 123, '족발볶음밥(1인) 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 123, '반찬 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 123, '쌈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 123, '콜라 500ml 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 124, '쟁반국수(2인) 추가', 13000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 124, '족발볶음밥(1인) 추가', 7000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 124, '반찬 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 124, '쌈 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 124, '콜라 500ml 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 125, '보쌈김치 1인분(230g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 125, '무김치 1인분(150g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 125, '고기 1인분(170g) 추가', 12000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 125, '쌈떡(호박, 쑥, 백년초) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 125, '콜라 1.25L 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 126, '보쌈김치 1인분(230g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 126, '무김치 1인분(150g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 126, '고기 1인분(170g) 추가', 12000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 126, '쌈떡(호박, 쑥, 백년초) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 126, '콜라 1.25L 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 127, '보쌈김치 1인분(230g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 127, '무김치 1인분(150g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 127, '고기 1인분(170g) 추가', 12000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 127, '쌈떡(호박, 쑥, 백년초) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 127, '콜라 1.25L 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 128, '보쌈김치 1인분(230g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 128, '무김치 1인분(150g) 추가', 11000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 128, '고기 1인분(170g) 추가', 12000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 128, '쌈떡(호박, 쑥, 백년초) 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 128, '콜라 1.25L 추가', 3000);





--야식(108)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 108, '할매닭발', '48113', '부산광역시 해운대구 청사포로 12', '1층',
            '0517024950', '\img\grandmother_logo.jpg', '\img\grandmother_logo.jpg', 16, 24, 20000, 40, 3000, '안녕하세요, 할매닭발입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 108, '꼬치황제 장산점', '48110', '부산광역시 해운대구 좌동순환로 280', '상가동 2층 201호',
            '0517012422', '\img\none.gif', '\img\none.gif', 16, 24, 10000, 30, 4000, '꼬치황제, 꼬치맛집, 존맛꼬치, 인생꼬치, 마약꼬치');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 108, '대박난전 해운대점', '48087', '부산광역시 해운대구 우동1로20번가길 31', '1층',
            '0517474578', '\img\daebak_logo.jpg', '\img\daebak_logo.jpg', 16, 24, 19000, 60, 3000, '당일 직접 모든걸 수제로 만드는 전 전문점 정성으로 대박난전 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 108, '345 비어', '48118', '부산광역시 해운대구 마린시티3로 23', '1층',
            '0517414242', '\img\none.gif', '\img\none.gif', 16, 24, 15000, 40, 3000, '345 비어입니다.');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 33, '쏘옥닭발', '23000', '아주매운맛/매운맛',
            '\img\grandmother_1.jpg', '\img\grandmother_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 33, '무뼈닭발', '21000', '아주매운맛/매운맛',
            '\img\grandmother_2.jpg', '\img\grandmother_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 33, '왕날개', '20000', '아주매운맛/매운맛',
            '\img\grandmother_3.jpg', '\img\grandmother_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 33, '통닭발', '20000', '아주매운맛/매운맛',
            '\img\grandmother_4.jpg', '\img\grandmother_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 34, '데리갈릭마요 닭꼬치', '4500', '데리야끼와 갈릭소스 그 위에 마늘토핑이 올라간 닭꼬치',
            '\img\ggochiking_1.jpg', '\img\ggochiking_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 34, '명란마요', '4500', '명란 위에 실파가 올라간 닭꼬치',
            '\img\ggochiking_2.jpg', '\img\ggochiking_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 34, '황제닭꼬치 4종', '16000', '갈릭솔트, 데리야끼, 매콤달콤, 매운맛 4가지 입니다.',
            '\img\ggochiking_3.jpg', '\img\ggochiking_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 34, '닭꼬치', '4500', '갈릭솔트, 데리야끼, 매콤달콤, 매운맛 중 1가지 선택하세요.',
            '\img\ggochiking_4.jpg', '\img\ggochiking_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 35, '대박모듬전', '27000', '전 10종류, 김치전 또는 부추전 가능',
            '\img\daebak_1.jpg', '\img\daebak_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 35, '소고기 육전', '20000', '말이 필요없는 소고기 육전입니다.',
            '\img\daebak_2.jpg', '\img\daebak_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 35, '오동통 새우전', '19000', '오동통한 새우로 만든 전입니다.',
            '\img\daebak_3.jpg', '\img\daebak_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 35, '수제 동그랑땡', '19000', '두부섞은 동그랑땡이랑 차원이 다른 100% 고기로 만든 동그랑땡입니다.',
            '\img\daebak_4.jpg', '\img\daebak_4.jpg');

INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 36, '빠삭먹태', '14500', '먹태+먹태껍질튀김+먹태소스',
            '\img\345beer_1.jpg', '\img\345beer_1.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 36, '아구포(3장)', '11500', '아구포3장+고추마요소스',
            '\img\345beer_2.jpg', '\img\345beer_2.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 36, '나막스', '13500', '나막스+고추마요소스',
            '\img\345beer_3.jpg', '\img\345beer_3.jpg');
INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
    VALUES (food_id_seq.NEXTVAL, 36, '노가리', '13500', '노가리+고추마요소스',
            '\img\345beer_4.jpg', '\img\345beer_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 129, '푸딩 계란찜 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 129, '오뎅탕 추가', 15000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 129, '주먹밥 3개 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 129, '쿨피스 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 130, '푸딩 계란찜 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 130, '오뎅탕 추가', 15000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 130, '주먹밥 3개 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 130, '쿨피스 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 131, '푸딩 계란찜 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 131, '오뎅탕 추가', 15000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 131, '주먹밥 3개 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 131, '쿨피스 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 132, '푸딩 계란찜 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 132, '오뎅탕 추가', 15000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 132, '주먹밥 3개 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 132, '쿨피스 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 133, '소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 133, '콜라 500ml 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 134, '소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 134, '콜라 500ml 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 135, '소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 135, '콜라 500ml 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 136, '소스 추가', 500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 136, '콜라 500ml 추가', 1500);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 137, '황태육수 어묵탕 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 137, '즉석밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 137, '탄산음료(355ml) 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 137, '탄산수 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 138, '황태육수 어묵탕 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 138, '즉석밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 138, '탄산음료(355ml) 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 138, '탄산수 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 139, '황태육수 어묵탕 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 139, '즉석밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 139, '탄산음료(355ml) 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 139, '탄산수 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 140, '황태육수 어묵탕 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 140, '즉석밥 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 140, '탄산음료(355ml) 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 140, '탄산수 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 141, '소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 141, '쥐포(3장) 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 141, '콜라 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 142, '소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 142, '쥐포(3장) 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 142, '콜라 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 143, '소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 143, '쥐포(3장) 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 143, '콜라 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 144, '소스 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 144, '쥐포(3장) 추가', 5000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 144, '콜라 추가', 2000);





--한식(109)
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 109, '두마리찜닭 두찜', '48088', '부산광역시 해운대구 우동1로 83', '103호',
            '0517449282', '\img\two.jpg', '\img\two.jpg', 8, 23, 12000, 65, 3000, '두마리찜닭 두찜 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 109, '일미리금계찜닭', '48082', '부산광역시 해운대구 좌동로63번길 46', '1층',
            '0517046630', '\img\one.jpg', '\img\one.jpg', 8, 23, 21000, 55, 2000, '일미리금계찜닭 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 109, '서울깍두기', '48106', '부산광역시 해운대구 세실로69번길 19', '블루스퀘어/블루스카이 B동 101호',
            '0517030085', '\img\seoul.jpg', '\img\seoul.jpg', 8, 23, 15000, 55, 3000, '서울깍두기 해운대점입니다.');
INSERT INTO bm_store
    VALUES (store_id_seq.NEXTVAL, 109, '맛나감자탕', '48059', '부산광역시 해운대구 센텀동로 9', '트럼프월드센텀아파트',
            '050714007767', '\img\taste.jpg', '\img\taste.jpg', 8, 23, 26000, 60, 1000, '맛나감자탕 해운대점입니다.');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 37, '까만찜닭', '23800', '까만 찜닭입니다', '\img\two_1.jpg', '\img\two_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 37, '빨간찜닭', '23800', '빨간 찜닭입니다', '\img\two_2.jpg', '\img\two_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 37, '로제찜닭', '27800', '로제 찜닭입니다', '\img\two_3.jpg', '\img\two_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 37, '묵은지찜닭', '27800', '묵은지 찜닭입니다', '\img\two_4.jpg', '\img\two_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 38, '누룽바베큐 찜닭', '27000', '누룽바베큐 찜닭입니다', '\img\one_1.jpg', '\img\one_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 38, '구름치즈찜닭', '27000', '구름치즈 찜닭입니다', '\img\one_2.jpg', '\img\one_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 38, '순살 금계찜닭', '24000', '순살 금계찜닭입니다', '\img\one_3.jpg', '\img\one_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 38, '레드파스타 찜닭', '27000', '레드파스타 찜닭입니다', '\img\one_4.jpg', '\img\one_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 39, '한우곰탕', '9000', '한우 곰탕입니다', '\img\seoul_1.jpg', '\img\seoul_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 39, '설렁탕', '9000', '설렁탕입니다', '\img\seoul_2.jpg', '\img\seoul_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 39, '한우육개장', '9000', '한우 육개장입니다', '\img\seoul_3.jpg', '\img\seoul_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 39, '갈비탕', '14000', '갈비탕입니다', '\img\seoul_4.jpg', '\img\seoul_4.jpg');

INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 40, '맛나 감자탕', '26000', '맛나 감자탕입니다', '\img\taste_1.jpg', '\img\taste_1.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 40, '맛나 뼈찜', '33000', '맛나 뼈찜입니다', '\img\taste_2.jpg', '\img\taste_2.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 40, '맛나 해물뼈찜', '42000', '맛나 해물뼈찜입니다', '\img\taste_3.jpg', '\img\taste_3.jpg');
INSERT INTO bm_food VALUES (food_id_seq.NEXTVAL, 40, '목뼈 해장국', '10000', '목뼈 해장국입니다', '\img\taste_4.jpg', '\img\taste_4.jpg');

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 145, '모짜렐라치즈 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 145, '감자 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 145, '고구마 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 145, '감자만두 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 146, '모짜렐라치즈 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 146, '감자 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 146, '고구마 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 146, '감자만두 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 147, '모짜렐라치즈 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 147, '감자 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 147, '고구마 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 147, '감자만두 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 148, '모짜렐라치즈 추가', 4000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 148, '감자 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 148, '고구마 3개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 148, '감자만두 추가', 3000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 149, '부들부들 푸딩계란찜 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 149, '납작당면만두 5개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 149, '치즈볼 3개 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 149, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 150, '부들부들 푸딩계란찜 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 150, '납작당면만두 5개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 150, '치즈볼 3개 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 150, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 151, '부들부들 푸딩계란찜 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 151, '납작당면만두 5개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 151, '치즈볼 3개 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 151, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 152, '부들부들 푸딩계란찜 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 152, '납작당면만두 5개 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 152, '치즈볼 3개 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 152, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 153, '사리 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 153, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 154, '사리 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 154, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 155, '사리 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 155, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 156, '사리 추가', 1000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 156, '공기밥 1개 추가', 1000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 157, '우동사리 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 157, '수제비 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 157, '당면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 157, '라면 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 157, '우거지 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 158, '우동사리 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 158, '수제비 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 158, '당면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 158, '라면 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 158, '우거지 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 159, '우동사리 추가', 3000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 159, '수제비 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 159, '당면 추가', 2000);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 159, '라면 추가', 1500);
INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 159, '우거지 추가', 2000);

INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 160, '공기밥 1개 추가', 1000);



COMMIT;



--테스트용 가게
--INSERT INTO bm_store
--    VALUES (store_id_seq.NEXTVAL, 100, '테스트용 가게', '48095', '부산광역시 해운대구 중동2로 11', '해운대구청',
--            '0517494000', '\img\none.gif', '\img\none.gif', 6, 24, 1, 10, 0, '테스트용 가게입니다.');
--            
--INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
--    VALUES (food_id_seq.NEXTVAL, 41, '테스트용 메뉴 1', '1', '테스트용 메뉴입니다.',
--            '\img\none.gif', '\img\none.gif');
--INSERT INTO bm_food (id, store_id, food_name, food_price, food_dec, food_img, food_thumb)
--    VALUES (food_id_seq.NEXTVAL, 41, '테스트용 메뉴 2', '1', '테스트용 메뉴입니다.',
--            '\img\none.gif', '\img\none.gif');
--
--INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 161, '테스트용 추가메뉴 1', 1);
--INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 161, '테스트용 추가메뉴 2', 1);
--INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 161, '테스트용 추가메뉴 3', 1);
--
--INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 162, '테스트용 추가메뉴 1', 1);
--INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 162, '테스트용 추가메뉴 2', 1);
--INSERT INTO bm_food_option VALUES (option_id_seq.NEXTVAL, 162, '테스트용 추가메뉴 3', 1);





--SELECT * FROM bm_food;
--SELECT * FROM bm_food_option;
--SELECT * FROM bm_gift_card;
--SELECT * FROM bm_likes;
--SELECT * FROM bm_order_detail_non_user;
--SELECT * FROM bm_order_detail_user;
--SELECT * FROM bm_order_non_user;
--SELECT * FROM bm_order_user;
--SELECT * FROM bm_point;
--SELECT * FROM bm_review;
--SELECT * FROM bm_store;
--SELECT * FROM bm_user;
--SELECT * FROM bm_my_store;


--관리자로 변경
--UPDATE bm_user SET role = 'ROLE_ADMIN' WHERE id = 1;

--관리자 가게 추가
--INSERT INTO bm_my_store VALUES (1, 1);
--INSERT INTO bm_my_store VALUES (1, 5);
--INSERT INTO bm_my_store VALUES (1, 9);
--INSERT INTO bm_my_store VALUES (1, 13);
--INSERT INTO bm_my_store VALUES (1, 17);
--INSERT INTO bm_my_store VALUES (1, 21);
--INSERT INTO bm_my_store VALUES (1, 25);
--INSERT INTO bm_my_store VALUES (1, 29);
--INSERT INTO bm_my_store VALUES (1, 33);
--INSERT INTO bm_my_store VALUES (1, 37);
--INSERT INTO bm_my_store VALUES (1, 41);

--사용자로 변경
--UPDATE bm_user SET role = 'ROLE_USER' WHERE id = 1;
