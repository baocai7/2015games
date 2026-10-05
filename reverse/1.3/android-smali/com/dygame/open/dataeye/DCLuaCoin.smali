.class public Lcom/dygame/open/dataeye/DCLuaCoin;
.super Ljava/lang/Object;
.source "DCLuaCoin.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static gain(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 6
    .param p0, "id"    # Ljava/lang/String;
    .param p1, "coinType"    # Ljava/lang/String;
    .param p2, "gain"    # Ljava/lang/String;
    .param p3, "left"    # Ljava/lang/String;

    .prologue
    .line 18
    invoke-static {p2}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    move-object v0, p0

    move-object v1, p1

    invoke-static/range {v0 .. v5}, Lcom/dataeye/DCCoin;->gain(Ljava/lang/String;Ljava/lang/String;JJ)V

    .line 19
    return-void
.end method

.method public static gainInLevel(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "id"    # Ljava/lang/String;
    .param p1, "coinType"    # Ljava/lang/String;
    .param p2, "gain"    # Ljava/lang/String;
    .param p3, "left"    # Ljava/lang/String;
    .param p4, "levelId"    # Ljava/lang/String;

    .prologue
    .line 22
    invoke-static {p2}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    move-object v0, p0

    move-object v1, p1

    move-object v6, p4

    invoke-static/range {v0 .. v6}, Lcom/dataeye/DCCoin;->gainInLevel(Ljava/lang/String;Ljava/lang/String;JJLjava/lang/String;)V

    .line 23
    return-void
.end method

.method public static lost(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 6
    .param p0, "id"    # Ljava/lang/String;
    .param p1, "coinType"    # Ljava/lang/String;
    .param p2, "lost"    # Ljava/lang/String;
    .param p3, "left"    # Ljava/lang/String;

    .prologue
    .line 10
    invoke-static {p2}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    move-object v0, p0

    move-object v1, p1

    invoke-static/range {v0 .. v5}, Lcom/dataeye/DCCoin;->lost(Ljava/lang/String;Ljava/lang/String;JJ)V

    .line 11
    return-void
.end method

.method public static lostInLevel(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "id"    # Ljava/lang/String;
    .param p1, "coinType"    # Ljava/lang/String;
    .param p2, "lost"    # Ljava/lang/String;
    .param p3, "left"    # Ljava/lang/String;
    .param p4, "levelId"    # Ljava/lang/String;

    .prologue
    .line 14
    invoke-static {p2}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v2

    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    move-object v0, p0

    move-object v1, p1

    move-object v6, p4

    invoke-static/range {v0 .. v6}, Lcom/dataeye/DCCoin;->lostInLevel(Ljava/lang/String;Ljava/lang/String;JJLjava/lang/String;)V

    .line 15
    return-void
.end method

.method public static setCoinNum(Ljava/lang/String;Ljava/lang/String;)V
    .locals 2
    .param p0, "coinNum"    # Ljava/lang/String;
    .param p1, "coinType"    # Ljava/lang/String;

    .prologue
    .line 7
    invoke-static {p0}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v0

    invoke-static {v0, v1, p1}, Lcom/dataeye/DCCoin;->setCoinNum(JLjava/lang/String;)V

    .line 8
    return-void
.end method
