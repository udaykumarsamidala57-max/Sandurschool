<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!-- Common admin footer (self-contained styles) -->
<style type="text/css">
    .srs-footer {
        all: initial;
        box-sizing: border-box;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        flex-wrap: wrap;
        width: 100%;
        padding: 12px 20px;
        background: #ffffff;
        border-top: 1px solid #dddbda;
        font-family: 'Salesforce Sans', -apple-system, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        font-size: 12px;
        line-height: 1.5;
        color: #5c5c5c;
    }
    .srs-footer b { font-weight: 700; color: #181818; }
    .srs-footer .sep { color: #c9c9c9; margin: 0 6px; }
</style>
<footer class="srs-footer">
    <span>&copy; <%= java.time.Year.now() %> Website Admin</span>
    <span>Developed and Maintained by : <b>SSS IT - Office Central</b></span>
</footer>
