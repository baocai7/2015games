.class public Lcom/dygame/open/dataeye/DCLuaEvent;
.super Ljava/lang/Object;
.source "DCLuaEvent.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static onEvent(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "eventId"    # Ljava/lang/String;
    .param p1, "label"    # Ljava/lang/String;
    .param p2, "map"    # Ljava/lang/String;

    .prologue
    .line 43
    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, ""

    invoke-virtual {p2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 44
    invoke-static {p0}, Lcom/dataeye/DCEvent;->onEvent(Ljava/lang/String;)V

    .line 56
    :cond_0
    :goto_0
    return-void

    .line 47
    :cond_1
    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 48
    invoke-static {p0, p1}, Lcom/dataeye/DCEvent;->onEvent(Ljava/lang/String;Ljava/lang/String;)V

    .line 51
    :cond_2
    const-string v1, ""

    invoke-virtual {p2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 52
    invoke-static {p2}, Lcom/dygame/open/dataeye/DCLuaEvent;->parseJsonMap(Ljava/lang/String;)Ljava/util/HashMap;

    move-result-object v0

    .line 53
    .local v0, "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-static {p0, v0}, Lcom/dataeye/DCEvent;->onEvent(Ljava/lang/String;Ljava/util/Map;)V

    goto :goto_0
.end method

.method public static onEventBeforeLogin(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4
    .param p0, "eventId"    # Ljava/lang/String;
    .param p1, "map"    # Ljava/lang/String;
    .param p2, "duration"    # Ljava/lang/String;

    .prologue
    .line 33
    invoke-static {p1}, Lcom/dygame/open/dataeye/DCLuaEvent;->parseJsonMap(Ljava/lang/String;)Ljava/util/HashMap;

    move-result-object v0

    .line 34
    .local v0, "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-static {p2}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p0, v0, v2, v3}, Lcom/dataeye/DCEvent;->onEventBeforeLogin(Ljava/lang/String;Ljava/util/Map;J)V

    .line 35
    return-void
.end method

.method public static onEventBegin(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "eventId"    # Ljava/lang/String;
    .param p1, "map"    # Ljava/lang/String;
    .param p2, "flag"    # Ljava/lang/String;

    .prologue
    .line 75
    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, ""

    invoke-virtual {p2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 76
    invoke-static {p0}, Lcom/dataeye/DCEvent;->onEventBegin(Ljava/lang/String;)V

    .line 86
    :goto_0
    return-void

    .line 78
    :cond_0
    const-string v1, ""

    invoke-virtual {p2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 79
    invoke-static {p1}, Lcom/dygame/open/dataeye/DCLuaEvent;->parseJsonMap(Ljava/lang/String;)Ljava/util/HashMap;

    move-result-object v0

    .line 80
    .local v0, "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-static {p0, v0}, Lcom/dataeye/DCEvent;->onEventBegin(Ljava/lang/String;Ljava/util/Map;)V

    goto :goto_0

    .line 83
    .end local v0    # "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    :cond_1
    invoke-static {p1}, Lcom/dygame/open/dataeye/DCLuaEvent;->parseJsonMap(Ljava/lang/String;)Ljava/util/HashMap;

    move-result-object v0

    .line 84
    .restart local v0    # "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-static {p0, v0, p2}, Lcom/dataeye/DCEvent;->onEventBegin(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;)V

    goto :goto_0
.end method

.method public static onEventCount(Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "eventId"    # Ljava/lang/String;
    .param p1, "count"    # Ljava/lang/String;

    .prologue
    .line 39
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {p0, v0}, Lcom/dataeye/DCEvent;->onEventCount(Ljava/lang/String;I)V

    .line 40
    return-void
.end method

.method public static onEventDuration(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 4
    .param p0, "eventId"    # Ljava/lang/String;
    .param p1, "label"    # Ljava/lang/String;
    .param p2, "map"    # Ljava/lang/String;
    .param p3, "duration"    # Ljava/lang/String;

    .prologue
    .line 59
    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, ""

    invoke-virtual {p2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 60
    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p0, v2, v3}, Lcom/dataeye/DCEvent;->onEventDuration(Ljava/lang/String;J)V

    .line 72
    :cond_0
    :goto_0
    return-void

    .line 63
    :cond_1
    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_2

    .line 64
    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p0, p1, v2, v3}, Lcom/dataeye/DCEvent;->onEventDuration(Ljava/lang/String;Ljava/lang/String;J)V

    .line 67
    :cond_2
    const-string v1, ""

    invoke-virtual {p2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_0

    .line 68
    invoke-static {p2}, Lcom/dygame/open/dataeye/DCLuaEvent;->parseJsonMap(Ljava/lang/String;)Ljava/util/HashMap;

    move-result-object v0

    .line 69
    .local v0, "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p0, v0, v2, v3}, Lcom/dataeye/DCEvent;->onEventDuration(Ljava/lang/String;Ljava/util/Map;J)V

    goto :goto_0
.end method

.method public static onEventEnd(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "eventId"    # Ljava/lang/String;
    .param p1, "map"    # Ljava/lang/String;
    .param p2, "flag"    # Ljava/lang/String;

    .prologue
    .line 89
    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, ""

    invoke-virtual {p2, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_0

    .line 90
    invoke-static {p0}, Lcom/dataeye/DCEvent;->onEventEnd(Ljava/lang/String;)V

    .line 99
    :goto_0
    return-void

    .line 92
    :cond_0
    const-string v1, ""

    invoke-virtual {p1, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 93
    invoke-static {p0, p2}, Lcom/dataeye/DCEvent;->onEventEnd(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_0

    .line 96
    :cond_1
    invoke-static {p1}, Lcom/dygame/open/dataeye/DCLuaEvent;->parseJsonMap(Ljava/lang/String;)Ljava/util/HashMap;

    move-result-object v0

    .line 97
    .local v0, "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    invoke-static {p0, v0, p2}, Lcom/dataeye/DCEvent;->onEventEnd(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;)V

    goto :goto_0
.end method

.method private static parseJsonMap(Ljava/lang/String;)Ljava/util/HashMap;
    .locals 7
    .param p0, "jsonMap"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/String;",
            ")",
            "Ljava/util/HashMap",
            "<",
            "Ljava/lang/String;",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .prologue
    .line 14
    new-instance v4, Ljava/util/HashMap;

    invoke-direct {v4}, Ljava/util/HashMap;-><init>()V

    .line 16
    .local v4, "tMap":Ljava/util/HashMap;, "Ljava/util/HashMap<Ljava/lang/String;Ljava/lang/String;>;"
    :try_start_0
    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {v2, p0}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 17
    .local v2, "jObj":Lorg/json/JSONObject;
    invoke-virtual {v2}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v1

    .line 18
    .local v1, "it":Ljava/util/Iterator;, "Ljava/util/Iterator<*>;"
    :goto_0
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_0

    .line 19
    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/String;

    .line 20
    .local v3, "key":Ljava/lang/String;
    invoke-virtual {v2, v3}, Lorg/json/JSONObject;->getString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 21
    .local v5, "value":Ljava/lang/String;
    invoke-virtual {v4, v3, v5}, Ljava/util/HashMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Lorg/json/JSONException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 24
    .end local v1    # "it":Ljava/util/Iterator;, "Ljava/util/Iterator<*>;"
    .end local v2    # "jObj":Lorg/json/JSONObject;
    .end local v3    # "key":Ljava/lang/String;
    .end local v5    # "value":Ljava/lang/String;
    :catch_0
    move-exception v0

    .line 26
    .local v0, "e":Lorg/json/JSONException;
    invoke-virtual {v0}, Lorg/json/JSONException;->printStackTrace()V

    .line 28
    .end local v0    # "e":Lorg/json/JSONException;
    :cond_0
    return-object v4
.end method
