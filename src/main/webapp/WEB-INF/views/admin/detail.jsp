<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="/WEB-INF/views/layout/link.jsp"%>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=[kakao에서 발급받은 rest api key 입력]&libraries=services,clusterer,drawing"></script>

<link rel="stylesheet" href="/css/modal/modal.css">
<link rel="stylesheet" href="/css/store/detail.css">

<%@ include file="/WEB-INF/views/layout/header.jsp"%>
<%@ include file="/WEB-INF/views/store/storeDetail.jsp"%>
<%@ include file="/WEB-INF/views/layout/footer.jsp"%>
<%@ include file="/WEB-INF/views/modal/modal_food.jsp"%>
<%@ include file="/WEB-INF/views/modal/modal_adminDetail.jsp"%>

<link rel="stylesheet" href="/css/admin/modal_adminDetail.css">

<script type="text/javascript" src="/js/store/storeDetail.js"></script>
<script type="text/javascript" src="/js/admin/adminDetail.js"></script>
<script type="text/javascript" src="/js/utils/util.js"></script>

</body>
</html>