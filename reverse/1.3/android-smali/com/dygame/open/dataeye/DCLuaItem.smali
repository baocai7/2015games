.class public Lcom/dygame/open/dataeye/DCLuaItem;
.super Ljava/lang/Object;
.source "DCLuaItem.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .prologue
    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static buy(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 8
    .param p0, "itemId"    # Ljava/lang/String;
    .param p1, "itemType"    # Ljava/lang/String;
    .param p2, "itemCnt"    # Ljava/lang/String;
    .param p3, "vituralCurrency"    # Ljava/lang/String;
    .param p4, "currencyType"    # Ljava/lang/String;
    .param p5, "consumePoint"    # Ljava/lang/String;

    .prologue
    .line 8
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v3

    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    move-object v1, p0

    move-object v2, p1

    move-object v6, p4

    move-object v7, p5

    invoke-static/range {v1 .. v7}, Lcom/dataeye/DCItem;->buy(Ljava/lang/String;Ljava/lang/String;IJLjava/lang/String;Ljava/lang/String;)V

    .line 9
    return-void
.end method

.method public static buyInLevel(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 9
    .param p0, "itemId"    # Ljava/lang/String;
    .param p1, "itemType"    # Ljava/lang/String;
    .param p2, "itemCnt"    # Ljava/lang/String;
    .param p3, "vituralCurrency"    # Ljava/lang/String;
    .param p4, "currencyType"    # Ljava/lang/String;
    .param p5, "consumePoint"    # Ljava/lang/String;
    .param p6, "levelId"    # Ljava/lang/String;

    .prologue
    .line 12
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v3

    invoke-static {p3}, Ljava/lang/Long;->valueOf(Ljava/lang/String;)Ljava/lang/Long;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Long;->longValue()J

    move-result-wide v4

    move-object v1, p0

    move-object v2, p1

    move-object v6, p4

    move-object v7, p5

    move-object v8, p6

    invoke-static/range {v1 .. v8}, Lcom/dataeye/DCItem;->buyInLevel(Ljava/lang/String;Ljava/lang/String;IJLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 13
    return-void
.end method

.method public static consume(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "itemId"    # Ljava/lang/String;
    .param p1, "itemType"    # Ljava/lang/String;
    .param p2, "itemCnt"    # Ljava/lang/String;
    .param p3, "reason"    # Ljava/lang/String;

    .prologue
    .line 24
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {p0, p1, v0, p3}, Lcom/dataeye/DCItem;->consume(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V

    .line 25
    return-void
.end method

.method public static consumeInLevel(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "itemId"    # Ljava/lang/String;
    .param p1, "itemType"    # Ljava/lang/String;
    .param p2, "itemCnt"    # Ljava/lang/String;
    .param p3, "reason"    # Ljava/lang/String;
    .param p4, "levelId"    # Ljava/lang/String;

    .prologue
    .line 28
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {p0, p1, v0, p3, p4}, Lcom/dataeye/DCItem;->consumeInLevel(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)V

    .line 29
    return-void
.end method

.method public static get(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "itemId"    # Ljava/lang/String;
    .param p1, "itemType"    # Ljava/lang/String;
    .param p2, "itemCnt"    # Ljava/lang/String;
    .param p3, "reason"    # Ljava/lang/String;

    .prologue
    .line 16
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {p0, p1, v0, p3}, Lcom/dataeye/DCItem;->get(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;)V

    .line 17
    return-void
.end method

.method public static getInLevel(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 1
    .param p0, "itemId"    # Ljava/lang/String;
    .param p1, "itemType"    # Ljava/lang/String;
    .param p2, "itemCnt"    # Ljava/lang/String;
    .param p3, "reason"    # Ljava/lang/String;
    .param p4, "levelId"    # Ljava/lang/String;

    .prologue
    .line 20
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(Ljava/lang/String;)Ljava/lang/Integer;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v0

    invoke-static {p0, p1, v0, p3, p4}, Lcom/dataeye/DCItem;->getInLevel(Ljava/lang/String;Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)V

    .line 21
    return-void
.end method
