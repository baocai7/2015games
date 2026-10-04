.class public Lcn/uc/gamesdk/d/g;
.super Ljava/lang/Object;


# static fields
.field public static final a:C = 'f'


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static final a(Ljava/lang/CharSequence;Ljava/util/Date;)Ljava/lang/CharSequence;
    .locals 7

    new-instance v4, Ljava/util/GregorianCalendar;

    invoke-direct {v4}, Ljava/util/GregorianCalendar;-><init>()V

    invoke-virtual {v4, p1}, Ljava/util/Calendar;->setTime(Ljava/util/Date;)V

    invoke-static {p0, v4}, Landroid/text/format/DateFormat;->format(Ljava/lang/CharSequence;Ljava/util/Calendar;)Ljava/lang/CharSequence;

    move-result-object v0

    new-instance v5, Landroid/text/SpannableStringBuilder;

    invoke-direct {v5, v0}, Landroid/text/SpannableStringBuilder;-><init>(Ljava/lang/CharSequence;)V

    invoke-interface {p0}, Ljava/lang/CharSequence;->length()I

    move-result v1

    const/4 v0, 0x0

    move v3, v0

    move v0, v1

    :goto_0
    if-ge v3, v0, :cond_2

    const/4 v1, 0x1

    invoke-virtual {v5, v3}, Landroid/text/SpannableStringBuilder;->charAt(I)C

    move-result v2

    :goto_1
    add-int v6, v3, v1

    if-ge v6, v0, :cond_0

    add-int v6, v3, v1

    invoke-virtual {v5, v6}, Landroid/text/SpannableStringBuilder;->charAt(I)C

    move-result v6

    if-ne v6, v2, :cond_0

    add-int/lit8 v1, v1, 0x1

    goto :goto_1

    :cond_0
    packed-switch v2, :pswitch_data_0

    const/4 v2, 0x0

    :goto_2
    if-eqz v2, :cond_1

    add-int v0, v3, v1

    invoke-virtual {v5, v3, v0, v2}, Landroid/text/SpannableStringBuilder;->replace(IILjava/lang/CharSequence;)Landroid/text/SpannableStringBuilder;

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {v5}, Landroid/text/SpannableStringBuilder;->length()I

    move-result v0

    :cond_1
    add-int/2addr v1, v3

    move v3, v1

    goto :goto_0

    :pswitch_0
    const/16 v2, 0xe

    invoke-virtual {v4, v2}, Ljava/util/Calendar;->get(I)I

    move-result v2

    invoke-static {v2, v1}, Lcn/uc/gamesdk/d/g;->a(II)Ljava/lang/String;

    move-result-object v2

    goto :goto_2

    :cond_2
    instance-of v0, p0, Landroid/text/Spanned;

    if-eqz v0, :cond_3

    new-instance v0, Landroid/text/SpannedString;

    invoke-direct {v0, v5}, Landroid/text/SpannedString;-><init>(Ljava/lang/CharSequence;)V

    :goto_3
    return-object v0

    :cond_3
    invoke-virtual {v5}, Landroid/text/SpannableStringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    goto :goto_3

    :pswitch_data_0
    .packed-switch 0x66
        :pswitch_0
    .end packed-switch
.end method

.method private static final a(II)Ljava/lang/String;
    .locals 5

    const/4 v2, 0x0

    invoke-static {p0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge v1, p1, :cond_1

    new-array v3, p1, [C

    move v1, v2

    :goto_0
    if-ge v1, p1, :cond_0

    const/16 v4, 0x30

    aput-char v4, v3, v1

    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    :cond_0
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v4

    sub-int v4, p1, v4

    invoke-virtual {v0, v2, v1, v3, v4}, Ljava/lang/String;->getChars(II[CI)V

    new-instance v0, Ljava/lang/String;

    invoke-direct {v0, v3}, Ljava/lang/String;-><init>([C)V

    :cond_1
    return-object v0
.end method
